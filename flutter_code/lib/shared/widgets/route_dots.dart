// ═══════════════════════════════════════════════════════════════
// route_dots.dart - نقاط المسار العمودية (انطلاق → وجهة)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// دائرة خضراء (نقطة الانطلاق) → خط → مربع أحمر (الوجهة).
/// يُستخدم في بطاقة المسار وشاشات البحث/الرحلة.
class RouteDots extends StatelessWidget {
  /// ارتفاع الخط الواصل بين النقطتين.
  final double lineHeight;

  const RouteDots({super.key, this.lineHeight = 10});

  @override
  Widget build(BuildContext context) {
    final divider = Theme.of(context).dividerColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // نقطة الانطلاق
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: MishwarakColors.success,
            shape: BoxShape.circle,
          ),
        ),
        // الخط الواصل
        Container(
          width: 1.5,
          height: lineHeight,
          margin: const EdgeInsets.symmetric(vertical: 3),
          color: divider,
        ),
        // الوجهة
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: MishwarakColors.danger,
            borderRadius: BorderRadius.circular(1.5),
          ),
        ),
      ],
    );
  }
}
