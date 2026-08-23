// ═══════════════════════════════════════════════════════════════
// ride_repository.dart - إنشاء الرحلات وتتبّعها وتقييمها
// ═══════════════════════════════════════════════════════════════
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_service.dart';

/// السائق كما تعرضه شاشة الرحلة الجارية.
class RideDriver {
  final String id;
  final String fullName;
  final String phone;
  final double rating;
  final int completedTrips;
  final String carModel;
  final String carColor;
  final String plateNumber;
  final double? lat;
  final double? lng;

  const RideDriver({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.rating,
    required this.completedTrips,
    required this.carModel,
    required this.carColor,
    required this.plateNumber,
    this.lat,
    this.lng,
  });
}

/// رحلة كاملة كما تعرضها شاشتا البحث عن سائق والرحلة الجارية.
class RideDetails {
  final String id;
  final String status;
  final String? driverId;
  final String? vehicleTypeId;
  final String pickupAddress;
  final String destAddress;
  final double pickupLat;
  final double pickupLng;
  final double destLat;
  final double destLng;
  final int fare;

  const RideDetails({
    required this.id,
    required this.status,
    this.driverId,
    this.vehicleTypeId,
    required this.pickupAddress,
    required this.destAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.destLat,
    required this.destLng,
    required this.fare,
  });

  /// السائق في طريقه إلى الراكب (لم تبدأ الرحلة بعد).
  bool get isArriving =>
      status == 'driver_assigned' || status == 'arriving' || status == 'arrived';

  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  static RideDetails fromRow(Map<String, dynamic> row) => RideDetails(
        id: row['id'] as String,
        status: row['status'] as String? ?? 'requested',
        driverId: row['driver_id'] as String?,
        vehicleTypeId: row['vehicle_type_id'] as String?,
        pickupAddress: row['pickup_address'] as String? ?? '',
        destAddress: row['dest_address'] as String? ?? '',
        pickupLat: (row['pickup_lat'] as num?)?.toDouble() ?? 0,
        pickupLng: (row['pickup_lng'] as num?)?.toDouble() ?? 0,
        destLat: (row['dest_lat'] as num?)?.toDouble() ?? 0,
        destLng: (row['dest_lng'] as num?)?.toDouble() ?? 0,
        fare: (row['fare'] as num?)?.toInt() ?? 0,
      );
}

/// ملخّص رحلة كما تعرضه شاشة السجل.
class RideSummary {
  final String id;
  final DateTime requestedAt;
  final String fromAddress;
  final String toAddress;
  final int fare;
  final bool cancelled;
  final int? rating;

  const RideSummary({
    required this.id,
    required this.requestedAt,
    required this.fromAddress,
    required this.toAddress,
    required this.fare,
    this.cancelled = false,
    this.rating,
  });
}

class RideRepository {
  const RideRepository();

  /// ينشئ طلب رحلة جديد ويعيد معرّفها.
  ///
  /// يرمي [StateError] إذا لم يكن المستخدم مسجّل الدخول — لأن الرحلة
  /// بلا راكب لا معنى لها، ولا يصح تجاهل الخطأ بصمت هنا.
  Future<String> requestRide({
    required String vehicleTypeId,
    required String pickupAddress,
    required double pickupLat,
    required double pickupLng,
    required String destAddress,
    required double destLat,
    required double destLng,
    required int estimatedFare,
    int baseFare = 0,
    int distanceFare = 0,
    double distanceKm = 0,
    String paymentMethod = 'wallet',
  }) async {
    final user = SupabaseService.currentUser;
    if (user == null) {
      throw StateError('لا يمكن طلب رحلة قبل تسجيل الدخول.');
    }

    final row = await SupabaseService.client
        .from('rides')
        .insert({
          'passenger_id': user.id,
          'vehicle_type_id': vehicleTypeId,
          'status': 'requested',
          'pickup_address': pickupAddress,
          'pickup_lat': pickupLat,
          'pickup_lng': pickupLng,
          'dest_address': destAddress,
          'dest_lat': destLat,
          'dest_lng': destLng,
          'fare': estimatedFare,
          'base_fare': baseFare == 0 ? estimatedFare : baseFare,
          'distance_fare': distanceFare,
          'distance_km': distanceKm,
          'payment_method': paymentMethod,
        })
        .select('id')
        .single();

    return row['id'] as String;
  }

  /// يبحث عن أقرب سائق متاح لنوع المركبة المطلوب ويُعيّنه للرحلة.
  ///
  /// المطابقة تتم هنا في التطبيق مؤقتاً: نجلب السائقين المتاحين لهذا
  /// النوع ثم نرتّبهم بالمسافة. في الإنتاج يجب نقلها إلى Edge Function
  /// حتى لا يستطيع الراكب اختيار سائق بعينه أو تعيين سائق مشغول.
  ///
  /// يعيد السائق المعيَّن، أو `null` إن لم يتوفّر أحد.
  Future<RideDriver?> matchDriver({
    required String rideId,
    required String vehicleTypeId,
    required double pickupLat,
    required double pickupLng,
  }) async {
    if (!SupabaseService.isReady) return null;

    try {
      final rows = await SupabaseService.client
          .from('drivers')
          .select()
          .eq('is_online', true)
          .eq('vehicle_type_id', vehicleTypeId);

      if (rows.isEmpty) return null;

      // نستبعد من لا يملك موقعاً — لا يمكن ترتيبه بالقرب.
      final candidates = rows
          .where((r) => r['current_lat'] != null && r['current_lng'] != null)
          .toList();

      if (candidates.isEmpty) return null;

      candidates.sort((a, b) {
        final da = _distanceSquared(
          pickupLat,
          pickupLng,
          (a['current_lat'] as num).toDouble(),
          (a['current_lng'] as num).toDouble(),
        );
        final db = _distanceSquared(
          pickupLat,
          pickupLng,
          (b['current_lat'] as num).toDouble(),
          (b['current_lng'] as num).toDouble(),
        );
        return da.compareTo(db);
      });

      final nearest = candidates.first;
      final driverId = nearest['id'] as String;

      await SupabaseService.client.from('rides').update({
        'driver_id': driverId,
        'status': 'driver_assigned',
      }).eq('id', rideId);

      return _driverFromRow(nearest);
    } catch (e) {
      debugPrint('[RideRepository] فشلت مطابقة السائق ($e).');
      return null;
    }
  }

  /// مربّع المسافة — يكفي للمقارنة والترتيب دون تكلفة الجذر التربيعي.
  ///
  /// نصحّح فرق خطوط الطول بجيب تمام العرض، وإلا بدا السائقون شرقاً/غرباً
  /// أقرب مما هم عليه فعلاً.
  static double _distanceSquared(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    final dLat = lat1 - lat2;
    final dLng = (lng1 - lng2) * math.cos(lat1 * math.pi / 180);
    return dLat * dLat + dLng * dLng;
  }

  /// يتابع تغيّر حالة الرحلة لحظياً (requested → arriving → on_trip → completed).
  Stream<String> watchStatus(String rideId) {
    if (!SupabaseService.isReady) return const Stream.empty();

    return SupabaseService.client
        .from('rides')
        .stream(primaryKey: ['id'])
        .eq('id', rideId)
        .map((rows) => rows.isEmpty ? 'requested' : rows.first['status'] as String);
  }

  /// يتابع الرحلة كاملة لحظياً — الحالة والسائق المعيَّن والسعر.
  Stream<RideDetails?> watchRide(String rideId) {
    if (!SupabaseService.isReady) return const Stream.empty();

    return SupabaseService.client
        .from('rides')
        .stream(primaryKey: ['id'])
        .eq('id', rideId)
        .map((rows) => rows.isEmpty ? null : RideDetails.fromRow(rows.first));
  }

  Future<RideDetails?> fetchRide(String rideId) async {
    if (!SupabaseService.isReady) return null;

    try {
      final row = await SupabaseService.client
          .from('rides')
          .select()
          .eq('id', rideId)
          .maybeSingle();
      return row == null ? null : RideDetails.fromRow(row);
    } catch (e) {
      debugPrint('[RideRepository] فشل جلب الرحلة ($e).');
      return null;
    }
  }

  /// بيانات السائق المعيَّن — تُجلب منفصلة لأن `stream` لا يدعم الـ join.
  Future<RideDriver?> fetchDriver(String driverId) async {
    if (!SupabaseService.isReady) return null;

    try {
      final row = await SupabaseService.client
          .from('drivers')
          .select()
          .eq('id', driverId)
          .maybeSingle();

      return row == null ? null : _driverFromRow(row);
    } catch (e) {
      debugPrint('[RideRepository] فشل جلب السائق ($e).');
      return null;
    }
  }

  /// يتابع السائق لحظياً — موقعه يتغيّر أثناء الرحلة.
  Stream<RideDriver?> watchDriver(String driverId) {
    if (!SupabaseService.isReady) return const Stream.empty();

    return SupabaseService.client
        .from('drivers')
        .stream(primaryKey: ['id'])
        .eq('id', driverId)
        .map((rows) => rows.isEmpty ? null : _driverFromRow(rows.first));
  }

  static RideDriver _driverFromRow(Map<String, dynamic> row) => RideDriver(
        id: row['id'] as String,
        fullName: row['full_name'] as String? ?? '',
        phone: row['phone'] as String? ?? '',
        rating: (row['rating'] as num?)?.toDouble() ?? 5.0,
        completedTrips: (row['completed_trips'] as num?)?.toInt() ?? 0,
        carModel: row['car_model'] as String? ?? '',
        carColor: row['car_color'] as String? ?? '',
        plateNumber: row['plate_number'] as String? ?? '',
        lat: (row['current_lat'] as num?)?.toDouble(),
        lng: (row['current_lng'] as num?)?.toDouble(),
      );

  /// سجل رحلات المستخدم الحالي، الأحدث أولاً.
  Future<List<RideSummary>> fetchHistory({int limit = 50}) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('rides')
          .select('id, requested_at, pickup_address, dest_address, fare, status, '
              'ride_ratings(rating)')
          .eq('passenger_id', user.id)
          .order('requested_at', ascending: false)
          .limit(limit);

      return rows.map<RideSummary>((row) {
        // ride_ratings علاقة one-to-one لكنها ترجع كمصفوفة.
        final ratings = row['ride_ratings'] as List?;
        return RideSummary(
          id: row['id'] as String,
          requestedAt: DateTime.parse(row['requested_at'] as String),
          fromAddress: row['pickup_address'] as String? ?? '',
          toAddress: row['dest_address'] as String? ?? '',
          fare: (row['fare'] as num?)?.toInt() ?? 0,
          cancelled: row['status'] == 'cancelled',
          rating: (ratings != null && ratings.isNotEmpty)
              ? (ratings.first['rating'] as num?)?.toInt()
              : null,
        );
      }).toList();
    } catch (e) {
      debugPrint('[RideRepository] فشل جلب السجل ($e).');
      return const [];
    }
  }

  /// يلغي رحلة جارية.
  Future<void> cancelRide(String rideId, {String? reason}) async {
    if (!SupabaseService.isReady) return;

    await SupabaseService.client.from('rides').update({
      'status': 'cancelled',
      'cancel_reason': reason,
      'completed_at': DateTime.now().toIso8601String(),
    }).eq('id', rideId);
  }

  /// يرسل تقييم رحلة مكتملة.
  Future<void> submitRating({
    required String rideId,
    required int rating,
    List<String> tags = const [],
    int tip = 0,
    String? comment,
  }) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client.from('ride_ratings').insert({
      'ride_id': rideId,
      'passenger_id': user.id,
      'rating': rating,
      'tags': tags,
      'tip': tip,
      'comment': comment,
    });
  }
}

final rideRepositoryProvider = Provider((ref) => const RideRepository());

/// سجل الرحلات لشاشة "رحلاتي".
final rideHistoryProvider = FutureProvider<List<RideSummary>>(
  (ref) => ref.watch(rideRepositoryProvider).fetchHistory(),
);

/// متابعة رحلة بعينها لحظياً — تستخدمها شاشتا البحث عن سائق والرحلة الجارية.
final rideStreamProvider = StreamProvider.family<RideDetails?, String>(
  (ref, rideId) => ref.watch(rideRepositoryProvider).watchRide(rideId),
);

/// بيانات السائق المعيَّن للرحلة، متجدّدة لحظياً.
///
/// تدفّق لا جلبة واحدة، لأن موقع السائق يتغيّر أثناء الرحلة ويجب أن
/// تتحرّك علامته على الخريطة.
final rideDriverProvider = StreamProvider.family<RideDriver?, String>(
  (ref, driverId) => ref.watch(rideRepositoryProvider).watchDriver(driverId),
);
