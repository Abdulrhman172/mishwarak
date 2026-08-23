// ═══════════════════════════════════════════════════════════════
// profile_repository.dart - الملف الشخصي والعناوين وجهات الطوارئ
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future<void> updateProfile({String? fullName, String? email}) async {
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client.from('profiles').update({
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', user.id);
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
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client.from('saved_places').insert({
      'user_id': user.id,
      'label': label,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
    });
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
    final user = SupabaseService.currentUser;
    if (!SupabaseService.isReady || user == null) return;

    await SupabaseService.client.from('emergency_contacts').insert({
      'user_id': user.id,
      'name': name,
      'phone': phone,
    });
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
