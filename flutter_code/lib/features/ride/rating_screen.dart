import 'package:flutter/material.dart';
import '../../shared/widgets/placeholder_screen.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const PlaceholderScreen(title: 'تقييم الرحلة', icon: Icons.star_rounded);
}
