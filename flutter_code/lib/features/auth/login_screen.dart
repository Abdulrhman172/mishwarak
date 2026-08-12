// ═══════════════════════════════════════════════════════════════
// login_screen.dart - تسجيل الدخول برقم الهاتف
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController();

  /// أرقام اليمن المحلية 9 خانات (مثل 771234567).
  bool get _isValid => _phone.text.trim().length >= 9;

  @override
  void initState() {
    super.initState();
    _phone.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _submit() {
    context.push('${AppRoutes.otp}?phone=${_phone.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: MishwarakColors.primaryGradient,
                ),
                child: const Icon(
                  Icons.directions_car_filled_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(height: 24),
              Text('أهلاً بك 👋', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'أدخل رقم جوالك لإرسال رمز التحقق',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: MishwarakColors.lightTextMuted,
                ),
              ),
              const SizedBox(height: 28),

              // ═══ حقل الهاتف ═══
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                style: theme.textTheme.headlineMedium,
                decoration: InputDecoration(
                  hintText: '77 123 4567',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Text(
                      '+967',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: MishwarakColors.lightTextMuted,
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 0),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: theme.dividerColor,
                ),
                child: const Text('إرسال رمز التحقق'),
              ),

              const Spacer(),
              Text(
                'بمتابعتك أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: MishwarakColors.lightTextLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
