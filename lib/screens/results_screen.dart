import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import '../models/progress.dart';
import '../theme/app_theme.dart';
import '../widgets/star_display.dart';

class ResultsScreen extends StatefulWidget {
  final ActivityResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    if (widget.result.starsEarned >= 2) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String get _messageEmoji {
    if (widget.result.starsEarned == 3) return '🎉';
    if (widget.result.starsEarned == 2) return '👏';
    if (widget.result.starsEarned == 1) return '💪';
    return '🤗';
  }

  String get _message {
    if (widget.result.starsEarned == 3) return 'Perfetto!';
    if (widget.result.starsEarned == 2) return 'Molto bene!';
    if (widget.result.starsEarned == 1) return 'Buon lavoro!';
    return 'Keep trying!';
  }

  String get _subtitle {
    if (widget.result.starsEarned == 3) return 'You got them all right!';
    if (widget.result.starsEarned == 2) return 'Great job, keep it up!';
    if (widget.result.starsEarned == 1) return "You're getting there!";
    return "Practice makes perfect!";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Spacer(),

                  // Result emoji
                  Text(
                    _messageEmoji,
                    style: const TextStyle(fontSize: 80),
                  )
                      .animate()
                      .scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0, 0),
                        end: const Offset(1, 1),
                      ),

                  const SizedBox(height: 24),

                  // Message
                  Text(
                    _message,
                    style:
                        Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.primary,
                            ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 8),

                  Text(
                    _subtitle,
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // Stars
                  StarDisplay(
                    count: widget.result.starsEarned,
                    size: 56,
                  ).animate().fadeIn(delay: 700.ms, duration: 500.ms),

                  const SizedBox(height: 24),

                  // Score
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatItem(
                          label: 'Correct',
                          value:
                              '${widget.result.correctAnswers}/${widget.result.totalQuestions}',
                          emoji: '✅',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        _StatItem(
                          label: 'Accuracy',
                          value:
                              '${(widget.result.accuracy * 100).round()}%',
                          emoji: '🎯',
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        _StatItem(
                          label: 'Stars',
                          value: '+${widget.result.starsEarned}',
                          emoji: '⭐',
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 500.ms),

                  const Spacer(),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1100.ms, duration: 500.ms),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.orange,
                AppColors.green,
                AppColors.pink,
                AppColors.yellow,
                AppColors.blue,
              ],
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;

  const _StatItem({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
