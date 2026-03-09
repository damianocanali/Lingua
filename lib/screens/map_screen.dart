import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/vocabulary_data.dart';
import '../models/vocabulary.dart';
import '../providers/progress_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_theme.dart';
import 'activity_picker_screen.dart';

// Zigzag offsets — alternating left / center / right for a game-map feel
const _xOffsets = [0.25, 0.65, 0.25, 0.65, 0.25, 0.65, 0.25, 0.65];

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  int _starsForCategory(Map<String, int> categoryProgress, String categoryId) {
    final correct = categoryProgress[categoryId] ?? 0;
    if (correct >= 8) return 3;
    if (correct >= 4) return 2;
    if (correct >= 1) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    final profile = ref.watch(profileProvider);
    final categories = VocabularyData.categories;
    final screenWidth = MediaQuery.of(context).size.width;

    // Node geometry
    const nodeSize = 88.0;
    const verticalSpacing = 130.0;
    const topPadding = 100.0;
    final totalHeight = topPadding + categories.length * verticalSpacing + 80;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEEEBFF), Color(0xFFF8F9FE)],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textPrimary, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Learning Map',
                        style:
                            Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      // Mini profile badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(profile.avatarEmoji,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              profile.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable map
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: screenWidth,
                      height: totalHeight,
                      child: Stack(
                        children: [
                          // Path painter
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _MapPathPainter(
                                categories: categories,
                                xOffsets: _xOffsets,
                                nodeSize: nodeSize,
                                verticalSpacing: verticalSpacing,
                                topPadding: topPadding,
                                screenWidth: screenWidth,
                                categoryProgress: progress.categoryProgress,
                              ),
                            ),
                          ),

                          // Category nodes
                          ...List.generate(categories.length, (index) {
                            final cat = categories[index];
                            final stars = _starsForCategory(
                                progress.categoryProgress, cat.id);
                            final xFraction = _xOffsets[
                                index % _xOffsets.length];
                            final x = screenWidth * xFraction - nodeSize / 2;
                            final y = topPadding +
                                index * verticalSpacing -
                                nodeSize / 2;
                            return Positioned(
                              left: x,
                              top: y,
                              child: _MapNode(
                                category: cat,
                                stars: stars,
                                nodeSize: nodeSize,
                                index: index,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ActivityPickerScreen(
                                        categoryId: cat.id),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Path Painter ────────────────────────────────────────────────────────────

class _MapPathPainter extends CustomPainter {
  final List<Category> categories;
  final List<double> xOffsets;
  final double nodeSize;
  final double verticalSpacing;
  final double topPadding;
  final double screenWidth;
  final Map<String, int> categoryProgress;

  _MapPathPainter({
    required this.categories,
    required this.xOffsets,
    required this.nodeSize,
    required this.verticalSpacing,
    required this.topPadding,
    required this.screenWidth,
    required this.categoryProgress,
  });

  Offset _center(int index) {
    final x = screenWidth * xOffsets[index % xOffsets.length];
    final y = topPadding + index * verticalSpacing;
    return Offset(x, y);
  }

  bool _isVisited(int index) {
    final id = categories[index].id;
    return (categoryProgress[id] ?? 0) > 0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < categories.length - 1; i++) {
      final start = _center(i);
      final end = _center(i + 1);

      // Dashed background track
      _drawDashedLine(canvas, start, end,
          Paint()
            ..color = Colors.grey.shade300
            ..strokeWidth = 6
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);

      // Filled progress track
      if (_isVisited(i)) {
        _drawCurvedLine(
          canvas,
          start,
          end,
          Paint()
            ..color = AppColors.primary.withValues(alpha: 0.5)
            ..strokeWidth = 6
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  void _drawCurvedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    path.moveTo(start.dx, start.dy);
    final mid = Offset((start.dx + end.dx) / 2 + 30, (start.dy + end.dy) / 2);
    path.quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLength = 10.0;
    const gapLength = 8.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final dist = sqrt(dx * dx + dy * dy);
    final ux = dx / dist;
    final uy = dy / dist;
    double drawn = 0;
    bool drawing = true;
    while (drawn < dist) {
      final segLen = drawing ? dashLength : gapLength;
      final next = min(drawn + segLen, dist);
      if (drawing) {
        canvas.drawLine(
          Offset(start.dx + ux * drawn, start.dy + uy * drawn),
          Offset(start.dx + ux * next, start.dy + uy * next),
          paint,
        );
      }
      drawn = next;
      drawing = !drawing;
    }
  }

  @override
  bool shouldRepaint(_MapPathPainter old) =>
      old.categoryProgress != categoryProgress;
}

// ─── Map Node ────────────────────────────────────────────────────────────────

class _MapNode extends StatelessWidget {
  final Category category;
  final int stars;
  final double nodeSize;
  final int index;
  final VoidCallback onTap;

  const _MapNode({
    required this.category,
    required this.stars,
    required this.nodeSize,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    final done = stars > 0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle node
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: nodeSize,
            height: nodeSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done ? color : Colors.grey.shade200,
              border: Border.all(
                color: done ? color.withValues(alpha: 0.5) : Colors.grey.shade300,
                width: 4,
              ),
              boxShadow: done
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.45),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: TextStyle(fontSize: done ? 36 : 30),
              ),
            ),
          )
              .animate()
              .fadeIn(
                delay: Duration(milliseconds: 80 * index),
                duration: 400.ms,
              )
              .scale(
                begin: const Offset(0.6, 0.6),
                delay: Duration(milliseconds: 80 * index),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),

          const SizedBox(height: 6),

          // Category name
          Text(
            category.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: done ? AppColors.textPrimary : Colors.grey.shade400,
                ),
          ),

          const SizedBox(height: 4),

          // Star row
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(3, (i) {
              return Icon(
                i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                color: i < stars ? AppColors.star : Colors.grey.shade300,
                size: 18,
              );
            }),
          ),
        ],
      ),
    );
  }
}
