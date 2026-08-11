// ═══════════════════════════════════════════════════════════════
// home_drawer.dart - قائمة جانبية بسيطة
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('مِشوارَك', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('الملف الشخصي'),
              onTap: () => context.push('${AppRoutes.home}/profile'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: const Text('المحفظة'),
              onTap: () => context.push('${AppRoutes.home}/wallet'),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('سجل الرحلات'),
              onTap: () => context.push('${AppRoutes.home}/history'),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_none_rounded),
              title: const Text('الإشعارات'),
              onTap: () => context.push('${AppRoutes.home}/notifications'),
            ),
          ],
        ),
      ),
    );
  }
}
