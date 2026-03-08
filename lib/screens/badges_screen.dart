import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/badges_data.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Badges',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: BadgesData.allBadges.length,
          itemBuilder: (context, index) {
            final badge = BadgesData.allBadges[index];
            final isUnlocked = progress.earnedBadges.contains(badge.id);

            return Container(
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Colors.white
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color:
                              AppColors.primary.withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: isUnlocked
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isUnlocked ? badge.emoji : '🔒',
                    style: TextStyle(
                      fontSize: 48,
                      color: isUnlocked ? null : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    badge.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      badge.description,
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isUnlocked
                                    ? AppColors.textSecondary
                                    : Colors.grey.shade400,
                                fontSize: 13,
                              ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                )
                .scale(
                  begin: const Offset(0.8, 0.8),
                  delay: Duration(milliseconds: 100 * index),
                  duration: 400.ms,
                );
          },
        ),
      ),
    );
  }
}
