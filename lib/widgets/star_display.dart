import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StarDisplay extends StatelessWidget {
  final int count;
  final int maxStars;
  final double size;

  const StarDisplay({
    super.key,
    required this.count,
    this.maxStars = 3,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < count ? Icons.star_rounded : Icons.star_outline_rounded,
            color: index < count ? AppColors.star : Colors.grey.shade300,
            size: size,
          ),
        );
      }),
    );
  }
}
