import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/user_profile_entity.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<UserProfileEntity?>>(
  (ref) => ProfileNotifier(),
);

class ProfileNotifier extends StateNotifier<AsyncValue<UserProfileEntity?>> {
  ProfileNotifier() : super(const AsyncValue.loading()) {
    _loadProfile();
  }

  final _box = Hive.box('auth');

  Future<void> _loadProfile() async {
    try {
      final profileData = _box.get('userProfile');
      if (profileData != null) {
        final profile = UserProfileEntity.fromJson(
          Map<String, dynamic>.from(profileData as Map),
        );
        state = AsyncValue.data(profile);
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateProfile(UserProfileEntity profile) async {
    try {
      state = const AsyncValue.loading();

      final updatedProfile = profile.copyWith(
        updatedAt: DateTime.now(),
      );

      await _box.put('userProfile', updatedProfile.toJson());

      state = AsyncValue.data(updatedProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createProfile({
    required String name,
    required String email,
    String? phoneNumber,
    String? address,
    DateTime? dateOfBirth,
    String? photoPath,
  }) async {
    try {
      state = const AsyncValue.loading();

      final now = DateTime.now();
      final profile = UserProfileEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        address: address,
        dateOfBirth: dateOfBirth,
        photoPath: photoPath,
        createdAt: now,
        updatedAt: now,
      );

      await _box.put('userProfile', profile.toJson());

      state = AsyncValue.data(profile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteProfile() async {
    try {
      await _box.delete('userProfile');
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
