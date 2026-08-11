import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('اختر وجهتك')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'إلى أين؟',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // نقطة دخول مؤقتة لمعاينة شاشة اختيار المركبة
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.vehicle),
              icon: const Icon(Icons.directions_car),
              label: const Text('اختر مركبة (جامعة عدن)'),
            ),
            const SizedBox(height: 24),
            Text(
              'الوجهات الأخيرة',
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 8),
            _RecentTile(
              name: 'جامعة عدن',
              addr: 'خور مكسر',
              onTap: () => context.push(AppRoutes.vehicle),
            ),
            _RecentTile(
              name: 'مستشفى الجمهورية',
              addr: 'كريتر',
              onTap: () => context.push(AppRoutes.vehicle),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  final String name;
  final String addr;
  final VoidCallback onTap;

  const _RecentTile({
    required this.name,
    required this.addr,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history),
      title: Text(name),
      subtitle: Text(addr),
      trailing: const Icon(Icons.arrow_back, size: 18),
      onTap: onTap,
    );
  }
}
