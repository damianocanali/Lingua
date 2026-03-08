class UserProgress {
  final int totalStars;
  final int currentStreak;
  final int bestStreak;
  final int wordsLearned;
  final int activitiesCompleted;
  final List<String> earnedBadges;
  final Map<String, int> categoryProgress; // categoryId -> words mastered
  final DateTime? lastPlayedDate;

  const UserProgress({
    this.totalStars = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.wordsLearned = 0,
    this.activitiesCompleted = 0,
    this.earnedBadges = const [],
    this.categoryProgress = const {},
    this.lastPlayedDate,
  });

  UserProgress copyWith({
    int? totalStars,
    int? currentStreak,
    int? bestStreak,
    int? wordsLearned,
    int? activitiesCompleted,
    List<String>? earnedBadges,
    Map<String, int>? categoryProgress,
    DateTime? lastPlayedDate,
  }) {
    return UserProgress(
      totalStars: totalStars ?? this.totalStars,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      wordsLearned: wordsLearned ?? this.wordsLearned,
      activitiesCompleted: activitiesCompleted ?? this.activitiesCompleted,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
    );
  }
}

class ActivityResult {
  final int correctAnswers;
  final int totalQuestions;
  final int starsEarned;
  final Duration timeTaken;
  final String activityType;
  final String categoryId;

  const ActivityResult({
    required this.correctAnswers,
    required this.totalQuestions,
    required this.starsEarned,
    required this.timeTaken,
    required this.activityType,
    required this.categoryId,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
}

class Badge {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final bool Function(UserProgress) isUnlocked;

  const Badge({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.isUnlocked,
  });
}
