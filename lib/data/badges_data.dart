import '../models/progress.dart';

class BadgesData {
  static final List<Badge> allBadges = [
    Badge(
      id: 'first_steps',
      name: 'First Steps',
      emoji: '👣',
      description: 'Complete your first activity',
      isUnlocked: (p) => p.activitiesCompleted >= 1,
    ),
    Badge(
      id: 'word_explorer',
      name: 'Word Explorer',
      emoji: '🔍',
      description: 'Learn 10 words',
      isUnlocked: (p) => p.wordsLearned >= 10,
    ),
    Badge(
      id: 'star_collector',
      name: 'Star Collector',
      emoji: '⭐',
      description: 'Earn 25 stars',
      isUnlocked: (p) => p.totalStars >= 25,
    ),
    Badge(
      id: 'streak_starter',
      name: 'Streak Starter',
      emoji: '🔥',
      description: 'Get a 3-day streak',
      isUnlocked: (p) => p.bestStreak >= 3,
    ),
    Badge(
      id: 'vocabulary_hero',
      name: 'Vocabulary Hero',
      emoji: '🦸',
      description: 'Learn 30 words',
      isUnlocked: (p) => p.wordsLearned >= 30,
    ),
    Badge(
      id: 'super_star',
      name: 'Super Star',
      emoji: '🌟',
      description: 'Earn 100 stars',
      isUnlocked: (p) => p.totalStars >= 100,
    ),
    Badge(
      id: 'practice_pro',
      name: 'Practice Pro',
      emoji: '🏆',
      description: 'Complete 20 activities',
      isUnlocked: (p) => p.activitiesCompleted >= 20,
    ),
    Badge(
      id: 'streak_champion',
      name: 'Streak Champion',
      emoji: '💫',
      description: 'Get a 7-day streak',
      isUnlocked: (p) => p.bestStreak >= 7,
    ),
  ];
}
