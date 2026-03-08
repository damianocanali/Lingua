import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/vocabulary_data.dart';
import '../theme/app_theme.dart';
import 'flashcard_activity_screen.dart';
import 'emoji_match_activity_screen.dart';
import 'quiz_activity_screen.dart';

class ActivityPickerScreen extends StatelessWidget {
  final String categoryId;

  const ActivityPickerScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final category = VocabularyData.getCategoryById(categoryId);

    final activities = [
      _ActivityOption(
        title: 'Flashcards',
        subtitle: 'Match English & Italian',
        emoji: '🃏',
        color: AppColors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FlashcardActivityScreen(categoryId: categoryId),
          ),
        ),
      ),
      _ActivityOption(
        title: 'Emoji Match',
        subtitle: 'Match emoji to the word',
        emoji: '🎯',
        color: AppColors.pink,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EmojiMatchActivityScreen(categoryId: categoryId),
          ),
        ),
      ),
      _ActivityOption(
        title: 'Quiz',
        subtitle: 'Test your knowledge',
        emoji: '❓',
        color: AppColors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizActivityScreen(categoryId: categoryId),
          ),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(category?.emoji ?? '', style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),
            Text(
              category?.name ?? '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick an Activity!',
              style: Theme.of(context).textTheme.headlineLarge,
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            ...activities.asMap().entries.map((entry) {
              final index = entry.key;
              final activity = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _ActivityCard(activity: activity, index: index),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ActivityOption {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _ActivityOption({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onTap,
  });
}

class _ActivityCard extends StatelessWidget {
  final _ActivityOption activity;
  final int index;

  const _ActivityCard({required this.activity, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: activity.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: activity.color.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: activity.color.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: activity.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  activity.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    activity.subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: activity.color,
              size: 24,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 150 * index),
          duration: 400.ms,
        )
        .slideX(
          begin: 0.3,
          delay: Duration(milliseconds: 150 * index),
          duration: 400.ms,
        );
  }
}
