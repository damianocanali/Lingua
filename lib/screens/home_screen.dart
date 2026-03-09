import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../providers/progress_provider.dart';
import '../providers/profile_provider.dart';
import 'map_screen.dart';
import 'categories_screen.dart';
import 'badges_screen.dart';
import 'profile_setup_screen.dart';
import 'coloring_game_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              // ── Top bar ────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatChip(
                    color: AppColors.yellow,
                    child: Row(children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.star, size: 26),
                      const SizedBox(width: 5),
                      Text('${progress.totalStars}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  _StatChip(
                    color: AppColors.orange,
                    child: Row(children: [
                      const Text('🔥', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 5),
                      Text('${progress.currentStreak}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BadgesScreen())),
                    child: _StatChip(
                      color: AppColors.primary,
                      child: Row(children: [
                        const Text('🏆', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 5),
                        Text('${progress.earnedBadges.length}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Mascot & greeting ──────────────────────────────────────
              Text(
                profile.isSetup ? profile.avatarEmoji : '🦊',
                style: const TextStyle(fontSize: 80),
              )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                      duration: 3.seconds,
                      color: AppColors.yellow.withValues(alpha: 0.3))
                  .shake(
                      hz: 0.5,
                      curve: Curves.easeInOut,
                      duration: 4.seconds),

              const SizedBox(height: 10),

              Text(
                profile.isSetup ? 'Ciao, ${profile.name}!' : 'Ciao!',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

              const SizedBox(height: 4),

              Text(
                'What do you want to do today?',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

              const SizedBox(height: 28),

              // ── Mode cards ─────────────────────────────────────────────
              _ModeCard(
                emoji: '🗺️',
                title: 'Adventure Map',
                subtitle: 'Follow the story, unlock worlds',
                gradientColors: [AppColors.primary, const Color(0xFF9B8FFF)],
                delay: 400,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MapScreen())),
              ),

              const SizedBox(height: 12),

              _ModeCard(
                emoji: '📖',
                title: 'Learn Words',
                subtitle: 'Pick any topic and practise',
                gradientColors: [AppColors.blue, const Color(0xFF38B2AC)],
                delay: 520,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CategoriesScreen())),
              ),

              const SizedBox(height: 12),

              _ModeCard(
                emoji: '🎨',
                title: 'Color & Create',
                subtitle: 'Paint scenes, learn colours',
                gradientColors: [AppColors.pink, const Color(0xFFFF9F43)],
                delay: 640,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ColoringGameScreen())),
              ),

              const SizedBox(height: 20),

              // ── Footer ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileSetupScreen())),
                    icon: const Icon(Icons.edit_rounded,
                        size: 16, color: AppColors.textSecondary),
                    label: Text('Edit profile',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textSecondary)),
                  ),
                  Text('${progress.wordsLearned} words learned',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ).animate().fadeIn(delay: 750.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final Color color;
  final Widget child;
  const _StatChip({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final int delay;
  final VoidCallback onTap;

  const _ModeCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.38),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 42)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(
            delay: Duration(milliseconds: delay), duration: 500.ms)
        .slideY(
            begin: 0.25,
            delay: Duration(milliseconds: delay),
            duration: 500.ms);
  }
}
