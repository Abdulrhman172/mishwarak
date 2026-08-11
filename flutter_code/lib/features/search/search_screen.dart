import 'package:flutter/material.dart';
import '../../shared/widgets/placeholder_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'البحث عن وجهة', icon: Icons.search);
}
