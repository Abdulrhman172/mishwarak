import 'package:flutter/material.dart';
import '../../shared/widgets/placeholder_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderScreen(
      title: 'المحفظة', icon: Icons.account_balance_wallet_outlined);
}
