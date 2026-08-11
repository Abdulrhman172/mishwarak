// ═══════════════════════════════════════════════════════════════
// map_placeholder.dart - خلفية خريطة مؤقتة قابلة لإعادة الاستخدام
// ═══════════════════════════════════════════════════════════════
// TODO: استبدالها بـ google_maps_flutter بعد إضافة مفتاح API.
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MapPlaceholder extends StatelessWidget {
  /// أيقونة توضيحية في المنتصف (مثل نقطة الموقع أو مسار).
  final IconData icon;

  const MapPlaceholder({super.key, this.icon = Icons.map_outlined});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? MishwarakColors.mapBgDark : MishwarakColors.mapBgLight,
      child: Center(
        child: Icon(icon, size: 64, color: MishwarakColors.lightTextLight),
      ),
    );
  }
}
