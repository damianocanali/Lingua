import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import 'progress_provider.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProfileNotifier(prefs);
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  final SharedPreferences _prefs;

  ProfileNotifier(this._prefs) : super(const UserProfile()) {
    _loadProfile();
  }

  void _loadProfile() {
    final name = _prefs.getString('profile_name') ?? '';
    final avatar = _prefs.getString('profile_avatar') ?? '🦊';
    state = UserProfile(name: name, avatarEmoji: avatar);
  }

  void saveProfile(String name, String avatarEmoji) {
    _prefs.setString('profile_name', name.trim());
    _prefs.setString('profile_avatar', avatarEmoji);
    state = UserProfile(name: name.trim(), avatarEmoji: avatarEmoji);
  }
}
