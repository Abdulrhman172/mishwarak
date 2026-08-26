// ═══════════════════════════════════════════════════════════════
// ride_repository.dart - إنشاء الرحلات وتتبّعها وتقييمها
// ═══════════════════════════════════════════════════════════════
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
  final int discount;
  final String paymentMethod;

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
    this.discount = 0,
    this.paymentMethod = 'wallet',
  });

  /// السائق في طريقه إلى الراكب (لم تبدأ الرحلة بعد).
  bool get isArriving =>
      status == 'driver_assigned' || status == 'arriving' || status == 'arrived';

  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  /// انتهت الرحلة بأي نتيجة — لا تقبل تعديلاً بعدها.
  bool get isClosed => isCompleted || isCancelled;

  /// المبلغ المستحق فعلاً بعد الخصم.
  int get payable => (fare - discount).clamp(0, fare);

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
        discount: (row['discount'] as num?)?.toInt() ?? 0,
        paymentMethod: row['payment_method'] as String? ?? 'wallet',
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

  /// رحلة مكتملة بلا تقييم — يمكن تقييمها من السجل.
  bool get isRateable => !cancelled && rating == null;
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

  // ملاحظة: لا توجد مطابقة سائق في التطبيق.
  //
  // كانت `matchDriver()` تجلب السائقين المتاحين وتُعيّن الأقرب بتحديث
  // `rides.driver_id` من العميل. أُزيلت لثلاثة أسباب:
  //   • الراكب كان يستطيع تعيين سائق بعينه، أو سائقاً مشغولاً برحلة
  //     أخرى (الاستعلام لم يستبعد أصحاب الرحلات الجارية).
  //   • قراءتها تتطلّب كشف جدول السائقين كاملاً لكل مستخدم مسجَّل،
  //     بأسمائهم وأرقامهم ومواقعهم الحيّة.
  //   • `rides.driver_id` صار محميّاً بمُشغِّل `protect_ride_columns`،
  //     فالتحديث من العميل يُرَدّ بلا أثر.
  // التعيين الآن في `assign_nearest_driver` داخل القاعدة — راجع
  // القسم 14 من `supabase/schema.sql`.

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

  /// يتابع السائق لحظياً — موقعه يتغيّر أثناء الرحلة.
  ///
  /// تدفّق لا جلبة واحدة، لأن علامة السائق على الخريطة يجب أن تتحرّك.
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
  ///
  /// لا يرسل `completed_at`: مُشغِّل `stamp_ride_lifecycle` يختمها في
  /// القاعدة، وإرسالها من العميل يجعل وقت الإلغاء قابلاً للتزوير.
  ///
  /// [reasonCode] مفتاح ثابت (`passenger`) لا نص معروض، حتى يبقى
  /// العمود قابلاً للتجميع مهما اختلفت لغة الراكب.
  Future<void> cancelRide(String rideId, {String reasonCode = 'passenger'}) async {
    if (!SupabaseService.isReady) return;

    await SupabaseService.client.from('rides').update({
      'status': 'cancelled',
      'cancel_reason': reasonCode,
    }).eq('id', rideId);
  }

  /// يرسل تقييم رحلة مكتملة.
  ///
  /// [tagKeys] مفاتيح ثابتة (`safe_driving`) لا نصوصاً معروضة: النص
  /// المترجَم يختلف بلغة المُقيِّم، فيصبح العمود خليطاً لا يُجمَّع.
  /// الترجمة للعرض تتم في الواجهة — راجع `RatingTags`.
  ///
  /// `driver_id` لا يُرسل عمداً؛ يملؤه مُشغِّل `fill_rating_driver` من
  /// الرحلة نفسها، لأن الراكب لا يقرأ جدول السائقين ليؤكّده.
  Future<void> submitRating({
    required String rideId,
    required int rating,
    List<String> tagKeys = const [],
    int tip = 0,
    String? comment,
  }) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) {
      throw StateError('لا يمكن إرسال التقييم قبل تسجيل الدخول.');
    }

    await SupabaseService.client.from('ride_ratings').insert({
      'ride_id': rideId,
      'passenger_id': user.id,
      'rating': rating,
      'tags': tagKeys,
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
final rideDriverProvider = StreamProvider.family<RideDriver?, String>(
  (ref, driverId) => ref.watch(rideRepositoryProvider).watchDriver(driverId),
);
