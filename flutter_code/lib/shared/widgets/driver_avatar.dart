// ═══════════════════════════════════════════════════════════════
// driver_avatar.dart - صورة السائق الدائرية مع إطار وشارة تحقق
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class DriverAvatar extends StatelessWidget {
  final double size;

  /// حرف/حروف تظهر بدل الصورة (أول حرف من اسم السائق).
  final String initials;

  /// إظهار شارة التحقق الخضراء أسفل الصورة.
  final bool verified;

  const DriverAvatar({
    super.key,
    this.size = 60,
    required this.initials,
    this.verified = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = size * 0.36;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الصورة (حالياً حروف على تدرّج لوني)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: MishwarakColors.primaryGradient,
              border: Border.all(color: MishwarakColors.primary, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // شارة التحقق
          if (verified)
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                width: badge,
                height: badge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MishwarakColors.success,
                  border: Border.all(color: theme.cardColor, width: 2),
                ),
                child: Icon(Icons.check, size: badge * 0.6, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
