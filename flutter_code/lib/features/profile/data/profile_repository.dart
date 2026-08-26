// ═══════════════════════════════════════════════════════════════
// profile_repository.dart - الملف الشخصي والعناوين وجهات الطوارئ
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../../../core/supabase/supabase_service.dart';

class UserProfile {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final double rating;
  final int points;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.avatarUrl,
    required this.rating,
    required this.points,
    required this.createdAt,
  });
}

class SavedPlace {
  final String id;
  final String label; // home | work | other
  final String name;
  final String address;
  final double lat;
  final double lng;

  const SavedPlace({
    required this.id,
    required this.label,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

class EmergencyContact {
  final String id;
  final String name;
  final String phone;

  const EmergencyContact({
    required this.id,
    required this.name,
    required this.phone,
  });
}

class ProfileRepository {
  const ProfileRepository();

  Future<UserProfile?> fetchProfile() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return null;

    try {
      final row = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (row == null) return null;

      return UserProfile(
        id: row['id'] as String,
        fullName: row['full_name'] as String? ?? '',
        email: row['email'] as String?,
        phone: row['phone'] as String?,
        avatarUrl: row['avatar_url'] as String?,
        rating: (row['rating'] as num?)?.toDouble() ?? 5.0,
        points: (row['points'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    } catch (e) {
      debugPrint('[ProfileRepository] فشل جلب الملف ($e).');
      return null;
    }
  }

  /// يحدّث بيانات الملف الشخصي القابلة للتعديل.
  ///
  /// يرمي [StateError] بلا جلسة: هذه العملية يبدأها المستخدم صراحةً من
  /// شاشة التعديل، والصمت عند الفشل يجعله يظن أن التغيير حُفظ.
  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? locale,
  }) async {
    final user = _requireUser();

    await SupabaseService.client.from('profiles').update({
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (locale != null) 'locale': locale,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
  }

  /// ينشئ صف الملف الشخصي إن كان مفقوداً.
  ///
  /// مُشغِّل `handle_new_user` يغطّي التسجيل الجديد، لكن الحسابات
  /// الأقدم منه تبقى بلا صف فتظهر الشاشة فارغة بلا سبب واضح.
  Future<void> ensureProfile() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    try {
      await SupabaseService.client.from('profiles').upsert(
        {'id': user.id, 'phone': user.phone, 'email': user.email},
        onConflict: 'id',
        ignoreDuplicates: true,
      );
    } catch (e) {
      debugPrint('[ProfileRepository] تعذّر إنشاء الملف ($e).');
    }
  }

  Future<List<SavedPlace>> fetchSavedPlaces() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('saved_places')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      return rows
          .map<SavedPlace>((row) => SavedPlace(
                id: row['id'] as String,
                label: row['label'] as String? ?? 'other',
                name: row['name'] as String? ?? '',
                address: row['address'] as String? ?? '',
                lat: (row['lat'] as num?)?.toDouble() ?? 0,
                lng: (row['lng'] as num?)?.toDouble() ?? 0,
              ))
          .toList();
    } catch (e) {
      debugPrint('[ProfileRepository] فشل جلب العناوين ($e).');
      return const [];
    }
  }

  Future<void> addSavedPlace({
    required String label,
    required String name,
    required String address,
    required double lat,
    required double lng,
  }) async {
    final user = _requireUser();

    await SupabaseService.client.from('saved_places').insert({
      'user_id': user.id,
      'label': label,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
    });
  }

  Future<void> updateSavedPlace({
    required String id,
    String? label,
    String? name,
    String? address,
    double? lat,
    double? lng,
  }) async {
    final user = _requireUser();

    await SupabaseService.client
        .from('saved_places')
        .update({
          if (label != null) 'label': label,
          if (name != null) 'name': name,
          if (address != null) 'address': address,
          if (lat != null) 'lat': lat,
          if (lng != null) 'lng': lng,
        })
        .eq('id', id)
        // شرط زائد عن سياسة RLS عمداً: لو عُدِّلت السياسة يوماً يبقى
        // النطاق محصوراً في صفوف المستخدم نفسه.
        .eq('user_id', user.id);
  }

  Future<void> deleteSavedPlace(String id) async {
    final user = _requireUser();

    await SupabaseService.client
        .from('saved_places')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }

  Future<List<EmergencyContact>> fetchEmergencyContacts() async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return const [];

    try {
      final rows = await SupabaseService.client
          .from('emergency_contacts')
          .select()
          .eq('user_id', user.id)
          .order('created_at');

      return rows
          .map<EmergencyContact>((row) => EmergencyContact(
                id: row['id'] as String,
                name: row['name'] as String? ?? '',
                phone: row['phone'] as String? ?? '',
              ))
          .toList();
    } catch (e) {
      debugPrint('[ProfileRepository] فشل جلب جهات الطوارئ ($e).');
      return const [];
    }
  }

  Future<void> addEmergencyContact({
    required String name,
    required String phone,
  }) async {
    final user = _requireUser();

    await SupabaseService.client.from('emergency_contacts').insert({
      'user_id': user.id,
      'name': name,
      'phone': phone,
    });
  }

  Future<void> updateEmergencyContact({
    required String id,
    String? name,
    String? phone,
  }) async {
    final user = _requireUser();

    await SupabaseService.client
        .from('emergency_contacts')
        .update({
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        })
        .eq('id', id)
        .eq('user_id', user.id);
  }

  Future<void> deleteEmergencyContact(String id) async {
    final user = _requireUser();

    await SupabaseService.client
        .from('emergency_contacts')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }

  /// المستخدم الحالي، أو استثناء إن غاب.
  ///
  /// عمليات الكتابة تفشل بصوت مسموع بعكس القراءة: القراءة تكتفي
  /// بقائمة فارغة، أما الكتابة فيجب أن تُبلّغ المستخدم أنها لم تُحفظ.
  static User _requireUser() {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) {
      throw StateError('هذه العملية تتطلّب تسجيل الدخول.');
    }
    return user;
  }
}

final profileRepositoryProvider = Provider((ref) => const ProfileRepository());

final userProfileProvider = FutureProvider<UserProfile?>(
  (ref) => ref.watch(profileRepositoryProvider).fetchProfile(),
);

final savedPlacesProvider = FutureProvider<List<SavedPlace>>(
  (ref) => ref.watch(profileRepositoryProvider).fetchSavedPlaces(),
);

final emergencyContactsProvider = FutureProvider<List<EmergencyContact>>(
  (ref) => ref.watch(profileRepositoryProvider).fetchEmergencyContacts(),
);
