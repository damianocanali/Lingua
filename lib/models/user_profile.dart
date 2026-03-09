class UserProfile {
  final String name;
  final String avatarEmoji;

  const UserProfile({
    this.name = '',
    this.avatarEmoji = '🦊',
  });

  bool get isSetup => name.isNotEmpty;

  UserProfile copyWith({String? name, String? avatarEmoji}) {
    return UserProfile(
      name: name ?? this.name,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
    );
  }
}
