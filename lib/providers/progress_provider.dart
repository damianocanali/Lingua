import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/progress.dart';
import '../data/badges_data.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Must be overridden in ProviderScope');
});

final progressProvider =
    StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ProgressNotifier(prefs);
});

class ProgressNotifier extends StateNotifier<UserProgress> {
  final SharedPreferences _prefs;

  ProgressNotifier(this._prefs) : super(const UserProgress()) {
    _loadProgress();
  }

  void _loadProgress() {
    final json = _prefs.getString('user_progress');
    if (json != null) {
      final data = jsonDecode(json) as Map<String, dynamic>;
      state = UserProgress(
        totalStars: data['totalStars'] ?? 0,
        currentStreak: data['currentStreak'] ?? 0,
        bestStreak: data['bestStreak'] ?? 0,
        wordsLearned: data['wordsLearned'] ?? 0,
        activitiesCompleted: data['activitiesCompleted'] ?? 0,
        earnedBadges: List<String>.from(data['earnedBadges'] ?? []),
        categoryProgress:
            Map<String, int>.from(data['categoryProgress'] ?? {}),
        lastPlayedDate: data['lastPlayedDate'] != null
            ? DateTime.parse(data['lastPlayedDate'])
            : null,
      );
    }
  }

  void _saveProgress() {
    final data = {
      'totalStars': state.totalStars,
      'currentStreak': state.currentStreak,
      'bestStreak': state.bestStreak,
      'wordsLearned': state.wordsLearned,
      'activitiesCompleted': state.activitiesCompleted,
      'earnedBadges': state.earnedBadges,
      'categoryProgress': state.categoryProgress,
      'lastPlayedDate': state.lastPlayedDate?.toIso8601String(),
    };
    _prefs.setString('user_progress', jsonEncode(data));
  }

  void completeActivity(ActivityResult result) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = state.currentStreak;
    if (state.lastPlayedDate != null) {
      final lastPlayed = DateTime(
        state.lastPlayedDate!.year,
        state.lastPlayedDate!.month,
        state.lastPlayedDate!.day,
      );
      final difference = today.difference(lastPlayed).inDays;
      if (difference == 1) {
        newStreak += 1;
      } else if (difference > 1) {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    final newCategoryProgress =
        Map<String, int>.from(state.categoryProgress);
    newCategoryProgress[result.categoryId] =
        (newCategoryProgress[result.categoryId] ?? 0) + result.correctAnswers;

    state = state.copyWith(
      totalStars: state.totalStars + result.starsEarned,
      currentStreak: newStreak,
      bestStreak: newStreak > state.bestStreak ? newStreak : state.bestStreak,
      wordsLearned: state.wordsLearned + result.correctAnswers,
      activitiesCompleted: state.activitiesCompleted + 1,
      categoryProgress: newCategoryProgress,
      lastPlayedDate: now,
    );

    _checkBadges();
    _saveProgress();
  }

  void _checkBadges() {
    final newBadges = <String>[...state.earnedBadges];
    for (final badge in BadgesData.allBadges) {
      if (!newBadges.contains(badge.id) && badge.isUnlocked(state)) {
        newBadges.add(badge.id);
      }
    }
    if (newBadges.length != state.earnedBadges.length) {
      state = state.copyWith(earnedBadges: newBadges);
      _saveProgress();
    }
  }
}
