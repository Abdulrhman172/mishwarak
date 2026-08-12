// ═══════════════════════════════════════════════════════════════
// star_rating.dart - نجوم التقييم (للعرض أو للاختيار)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// نجوم للعرض فقط - تدعم النجمة النصفية (مثل 4.92).
class StarRating extends StatelessWidget {
  final double value;
  final double size;

  const StarRating({super.key, required this.value, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final filled = value >= i + 1;
        final half = !filled && value > i;
        return Icon(
          half ? Icons.star_half_rounded : Icons.star_rounded,
          size: size,
          color: (filled || half)
              ? MishwarakColors.accent
              : MishwarakColors.lightBorder,
        );
      }),
    );
  }
}

/// نجوم قابلة للنقر - تُستخدم في شاشة تقييم الرحلة.
class StarRatingInput extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  const StarRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final n = i + 1;
        final active = value >= n;
        return GestureDetector(
          onTap: () => onChanged(n),
          behavior: HitTestBehavior.opaque,
          child: AnimatedScale(
            scale: active ? 1.12 : 1,
            duration: const Duration(milliseconds: 150),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                active ? Icons.star_rounded : Icons.star_border_rounded,
                size: size,
                color: active
                    ? MishwarakColors.accent
                    : MishwarakColors.lightBorder,
              ),
            ),
          ),
        );
      }),
    );
  }
}
