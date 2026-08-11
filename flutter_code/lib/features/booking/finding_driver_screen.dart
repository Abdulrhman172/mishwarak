import 'package:flutter/material.dart';
import '../../shared/widgets/placeholder_screen.dart';

class FindingDriverScreen extends StatelessWidget {
  const FindingDriverScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
      title: 'جاري البحث عن سائق', icon: Icons.search_rounded);
}
