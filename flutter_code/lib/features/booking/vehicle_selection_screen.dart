import 'package:flutter/material.dart';
import '../../shared/widgets/placeholder_screen.dart';

class VehicleSelectionScreen extends StatelessWidget {
  const VehicleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
      title: 'اختيار نوع المركبة', icon: Icons.directions_car);
}
