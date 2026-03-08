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

class EmojiMatchActivityScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const EmojiMatchActivityScreen({super.key, required this.categoryId});

  @override
  ConsumerState<EmojiMatchActivityScreen> createState() =>
      _EmojiMatchActivityScreenState();
}

class _EmojiMatchActivityScreenState
    extends ConsumerState<EmojiMatchActivityScreen> {
  late List<VocabularyWord> _words;
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showingFeedback = false;
  String? _selectedEmoji;
  late List<String> _emojiOptions;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _words = List.from(VocabularyData.getWordsForCategory(widget.categoryId))
      ..shuffle(Random());
    if (_words.length > 5) _words = _words.sublist(0, 5);
    _generateEmojiOptions();
  }

  void _generateEmojiOptions() {
    final correctWord = _words[_currentIndex];
    final otherWords = VocabularyData.allWords
        .where((w) => w.id != correctWord.id && w.emoji != correctWord.emoji)
        .toList()
      ..shuffle(Random());
    final wrongEmojis = otherWords.take(3).map((w) => w.emoji).toList();
    _emojiOptions = [...wrongEmojis, correctWord.emoji]..shuffle(Random());
  }

  void _checkAnswer(String emoji) {
    if (_showingFeedback) return;
    final correct = _words[_currentIndex].emoji;
    setState(() {
      _selectedEmoji = emoji;
      _showingFeedback = true;
      if (emoji == correct) _correctCount++;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentIndex < _words.length - 1) {
        setState(() {
          _currentIndex++;
          _showingFeedback = false;
          _selectedEmoji = null;
          _generateEmojiOptions();
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
      activityType: 'emoji_match',
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
    final correctEmoji = word.emoji;
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
                    const AlwaysStoppedAnimation<Color>(AppColors.pink),
              ),
            ),

            const Spacer(),

            // Word display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.pink.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.pink.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Find the emoji for:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    word.italian,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '(${word.english})',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 40),

            // Emoji grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _emojiOptions.map((emoji) {
                final isSelected = _selectedEmoji == emoji;
                final isCorrect = emoji == correctEmoji;
                Color bgColor = Colors.white;
                Color borderColor = Colors.grey.shade200;

                if (_showingFeedback) {
                  if (isCorrect) {
                    bgColor = AppColors.correct.withValues(alpha: 0.2);
                    borderColor = AppColors.correct;
                  } else if (isSelected && !isCorrect) {
                    bgColor = AppColors.incorrect.withValues(alpha: 0.2);
                    borderColor = AppColors.incorrect;
                  }
                }

                return GestureDetector(
                  onTap: () => _checkAnswer(emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(emoji, style: const TextStyle(fontSize: 56)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
