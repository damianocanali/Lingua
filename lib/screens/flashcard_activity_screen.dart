import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/vocabulary_data.dart';
import '../models/vocabulary.dart';
import '../models/progress.dart';
import '../providers/progress_provider.dart';
import '../theme/app_theme.dart';
import 'results_screen.dart';

class FlashcardActivityScreen extends ConsumerStatefulWidget {
  final String categoryId;
  final bool fromMap;
  final int categoryIndex;

  const FlashcardActivityScreen({
    super.key,
    required this.categoryId,
    this.fromMap = false,
    this.categoryIndex = 0,
  });

  @override
  ConsumerState<FlashcardActivityScreen> createState() =>
      _FlashcardActivityScreenState();
}

class _FlashcardActivityScreenState
    extends ConsumerState<FlashcardActivityScreen> {
  late List<VocabularyWord> _words;
  int _currentIndex = 0;
  bool _showingFeedback = false;
  String? _selectedAnswer;
  int _correctCount = 0;
  late DateTime _startTime;
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _words = List.from(VocabularyData.getWordsForCategory(widget.categoryId))
      ..shuffle(Random());
    // Limit to 5 questions for ADHD-friendly short sessions
    if (_words.length > 5) _words = _words.sublist(0, 5);
    _generateOptions();
  }

  void _generateOptions() {
    final correctWord = _words[_currentIndex];
    final allWords = VocabularyData.allWords
        .where((w) => w.id != correctWord.id)
        .toList()
      ..shuffle(Random());
    final wrongAnswers = allWords.take(3).map((w) => w.italian).toList();
    _options = [...wrongAnswers, correctWord.italian]..shuffle(Random());
  }

  void _checkAnswer(String answer) {
    if (_showingFeedback) return;
    final correct = _words[_currentIndex].italian;
    setState(() {
      _selectedAnswer = answer;
      _showingFeedback = true;
      if (answer == correct) _correctCount++;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentIndex < _words.length - 1) {
        setState(() {
          _currentIndex++;
          _showingFeedback = false;
          _selectedAnswer = null;
          _generateOptions();
        });
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final result = ActivityResult(
      correctAnswers: _correctCount,
      totalQuestions: _words.length,
      starsEarned: _correctCount >= _words.length
          ? 3
          : _correctCount >= (_words.length * 0.6).ceil()
              ? 2
              : _correctCount > 0
                  ? 1
                  : 0,
      timeTaken: DateTime.now().difference(_startTime),
      activityType: 'flashcard',
      categoryId: widget.categoryId,
    );
    ref.read(progressProvider.notifier).completeActivity(result);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          result: result,
          fromMap: widget.fromMap,
          categoryIndex: widget.categoryIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = _words[_currentIndex];
    final correct = word.italian;
    final progress = (_currentIndex + 1) / _words.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded,
              color: AppColors.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${_currentIndex + 1} / ${_words.length}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.surface,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),

            const Spacer(),

            // Card with emoji and English word
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(word.emoji, style: const TextStyle(fontSize: 72))
                      .animate()
                      .scale(duration: 400.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 16),
                  Text(
                    word.english,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'What is this in Italian?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 32),

            // Answer options
            ...List.generate(_options.length, (i) {
              final option = _options[i];
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == correct;
              Color bgColor = Colors.white;
              Color borderColor = AppColors.primary.withValues(alpha: 0.3);

              if (_showingFeedback) {
                if (isCorrectAnswer) {
                  bgColor = AppColors.correct.withValues(alpha: 0.2);
                  borderColor = AppColors.correct;
                } else if (isSelected && !isCorrectAnswer) {
                  bgColor = AppColors.incorrect.withValues(alpha: 0.2);
                  borderColor = AppColors.incorrect;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => _checkAnswer(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: borderColor.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ),
                        if (_showingFeedback && isCorrectAnswer)
                          const Icon(Icons.check_circle_rounded,
                              color: AppColors.correct, size: 28),
                        if (_showingFeedback &&
                            isSelected &&
                            !isCorrectAnswer)
                          const Icon(Icons.cancel_rounded,
                              color: AppColors.incorrect, size: 28),
                      ],
                    ),
                  ),
                ),
              );
            }),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
