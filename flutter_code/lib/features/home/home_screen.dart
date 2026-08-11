// ═══════════════════════════════════════════════════════════════
// home_screen.dart - الشاشة الرئيسية (خريطة + Bottom Sheet)
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../shared/widgets/glass_button.dart';
import '../../shared/widgets/saved_place_card.dart';
import '../../shared/widgets/service_shortcut.dart';
import 'widgets/home_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      drawer: const HomeDrawer(),
      body: Builder(
        builder: (context) => Stack(
          children: [
            // ═══════════════ الخريطة (placeholder) ═══════════════
            // TODO: استبدال بـ GoogleMap بعد إضافة مفتاح Google Maps API
            // في web/index.html و android/ios، لأن الحزمة لا تدعم Windows desktop.
            Container(
              color: MishwarakColors.mapBgLight,
              child: const Center(
                child: Icon(Icons.map_outlined, size: 64, color: MishwarakColors.lightTextLight),
              ),
            ),

            // ═══════════════ الشريط العلوي ═══════════════
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    // زر القائمة
                    GlassButton(
                      icon: Icons.menu_rounded,
                      onTap: () => Scaffold.of(context).openDrawer(),
                    ),
                    const Spacer(),
                    // شارة المحفظة
                    GlassPill(
                      icon: Icons.account_balance_wallet_outlined,
                      iconColor: MishwarakColors.primary,
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          children: const [
                            TextSpan(text: '15,300 '),
                            TextSpan(
                              text: 'ر.ي',
                              style: TextStyle(
                                fontSize: 11,
                                color: MishwarakColors.lightTextMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ═══════════════ Floating Action Buttons ═══════════════
            Positioned(
              right: 12,
              bottom: 340,
              child: Column(
                children: [
                  GlassButton(
                    icon: Icons.my_location,
                    iconColor: MishwarakColors.primary,
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  GlassButton(
                    icon: Icons.shield_outlined,
                    iconColor: MishwarakColors.danger,
                    onTap: _showSosDialog,
                  ),
                ],
              ),
            ),

            // ═══════════════ Bottom Sheet ═══════════════
            DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: 0.42,
              minChildSize: 0.15,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 32,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Handle
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: theme.dividerColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          // ═══ التحية ═══
                          Text(
                            'مرحباً، أحمد 👋',
                            style: theme.textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'إلى أين تريد أن تذهب اليوم؟',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: MishwarakColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // ═══ خانة البحث ═══
                          _SearchButton(
                            onTap: () => context.push('${AppRoutes.home}/search'),
                          ),
                          const SizedBox(height: 14),

                          // ═══ الأماكن المحفوظة ═══
                          Row(
                            children: [
                              Expanded(
                                child: SavedPlaceCard(
                                  icon: Icons.home_outlined,
                                  label: 'المنزل',
                                  subtitle: 'كريتر',
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SavedPlaceCard(
                                  icon: Icons.work_outline,
                                  label: 'العمل',
                                  subtitle: 'المعلا',
                                  onTap: () {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SavedPlaceCard(
                                  icon: Icons.add,
                                  label: 'إضافة',
                                  subtitle: 'مكان جديد',
                                  isAdd: true,
                                  onTap: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // ═══ الخدمات السريعة ═══
                          GridView.count(
                            crossAxisCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.05,
                            children: const [
                              ServiceShortcut(
                                icon: Icons.directions_car,
                                label: 'اقتصادي',
                                color: MishwarakColors.secondary,
                              ),
                              ServiceShortcut(
                                icon: Icons.workspace_premium,
                                label: 'VIP',
                                color: MishwarakColors.accent,
                              ),
                              ServiceShortcut(
                                icon: Icons.female,
                                label: 'نساء',
                                color: Color(0xFFEC4899),
                              ),
                              ServiceShortcut(
                                icon: Icons.schedule,
                                label: 'حجز مسبق',
                                color: MishwarakColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSosDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('حالة طوارئ؟'),
        content: const Text('سيتم إرسال موقعك للسلطات وجهات الطوارئ المحفوظة.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              // TODO: تفعيل الطوارئ
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: MishwarakColors.danger),
            child: const Text('طلب المساعدة'),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.dividerColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: MishwarakColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search,
                  color: MishwarakColors.primary,
                  size: 18,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'ابحث عن وجهتك...',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: MishwarakColors.lightTextMuted,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: MishwarakColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'احجز الآن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
