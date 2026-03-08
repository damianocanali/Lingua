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

enum QuizDirection { englishToItalian, italianToEnglish }

class QuizActivityScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const QuizActivityScreen({super.key, required this.categoryId});

  @override
  ConsumerState<QuizActivityScreen> createState() =>
      _QuizActivityScreenState();
}

class _QuizActivityScreenState extends ConsumerState<QuizActivityScreen>
    with TickerProviderStateMixin {
  late List<VocabularyWord> _words;
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showingFeedback = false;
  String? _selectedAnswer;
  late List<String> _options;
  late DateTime _startTime;
  late QuizDirection _direction;
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _words = List.from(VocabularyData.getWordsForCategory(widget.categoryId))
      ..shuffle(Random());
    if (_words.length > 5) _words = _words.sublist(0, 5);

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    _setupQuestion();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _setupQuestion() {
    // Randomize direction each question for variety
    _direction = Random().nextBool()
        ? QuizDirection.englishToItalian
        : QuizDirection.italianToEnglish;
    _generateOptions();
    _timerController.reset();
    _timerController.forward();
    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_showingFeedback) {
        // Time's up - count as wrong
        _checkAnswer('');
      }
    });
  }

  void _generateOptions() {
    final correctWord = _words[_currentIndex];
    final allWords = VocabularyData.allWords
        .where((w) => w.id != correctWord.id)
        .toList()
      ..shuffle(Random());

    if (_direction == QuizDirection.englishToItalian) {
      final wrongAnswers = allWords.take(3).map((w) => w.italian).toList();
      _options = [...wrongAnswers, correctWord.italian]..shuffle(Random());
    } else {
      final wrongAnswers = allWords.take(3).map((w) => w.english).toList();
      _options = [...wrongAnswers, correctWord.english]..shuffle(Random());
    }
  }

  String get _correctAnswer {
    final word = _words[_currentIndex];
    return _direction == QuizDirection.englishToItalian
        ? word.italian
        : word.english;
  }

  void _checkAnswer(String answer) {
    if (_showingFeedback) return;
    _timerController.stop();
    final correct = _correctAnswer;
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
        });
        _setupQuestion();
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
      activityType: 'quiz',
      categoryId: widget.categoryId,
    );
    ref.read(progressProvider.notifier).completeActivity(result);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final word = _words[_currentIndex];
    final questionText = _direction == QuizDirection.englishToItalian
        ? word.english
        : word.italian;
    final directionHint = _direction == QuizDirection.englishToItalian
        ? 'What is this in Italian?'
        : 'What is this in English?';
    final progress = (_currentIndex + 1) / _words.length;
    final correct = _correctAnswer;

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
                    const AlwaysStoppedAnimation<Color>(AppColors.orange),
              ),
            ),

            const SizedBox(height: 16),

            // Timer bar
            AnimatedBuilder(
              animation: _timerController,
              builder: (context, child) {
                final value = 1.0 - _timerController.value;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      value > 0.3 ? AppColors.blue : AppColors.red,
                    ),
                  ),
                );
              },
            ),

            const Spacer(),

            // Question card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.orange.withValues(alpha: 0.15),
                    AppColors.yellow.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.orange.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(word.emoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    questionText,
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    directionHint,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 32),

            // Options
            ...List.generate(_options.length, (i) {
              final option = _options[i];
              final isSelected = _selectedAnswer == option;
              final isCorrectAnswer = option == correct;
              Color bgColor = Colors.white;
              Color borderColor = Colors.grey.shade200;

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
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option,
                            style: Theme.of(context).textTheme.titleLarge,
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
