// ═══════════════════════════════════════════════════════════════
// login_screen.dart - تسجيل الدخول برقم الهاتف
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'data/auth_repository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phone = TextEditingController();
  bool _isSending = false;
  String? _error;

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

  Future<void> _submit() async {
    final phone = '+967${_phone.text.trim()}';
    setState(() {
      _isSending = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).sendOtp(phone);
      if (!mounted) return;
      context.push('${AppRoutes.otp}?phone=${_phone.text.trim()}');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = L10n.of(context).sendOtpFailed);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

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
              Text(l10n.welcome, style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                l10n.loginPrompt,
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
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isValid && !_isSending ? _submit : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: theme.dividerColor,
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.sendOtp),
              ),

              const Spacer(),
              Text(
                l10n.termsNotice,
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
