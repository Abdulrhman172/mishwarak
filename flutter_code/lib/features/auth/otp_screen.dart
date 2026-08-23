// ═══════════════════════════════════════════════════════════════
// otp_screen.dart - إدخال رمز التحقق (4 خانات) مع عدّاد إعادة الإرسال
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'data/auth_repository.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _length = 6;

  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _nodes = List.generate(_length, (_) => FocusNode());

  int _secondsLeft = 30;
  Timer? _timer;
  bool _isVerifying = false;
  bool _isResending = false;
  String? _error;

  String get _code => _controllers.map((c) => c.text).join();
  bool get _isComplete => _code.length == _length;
  String get _fullPhone => '+967${widget.phoneNumber}';

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() => _secondsLeft = 30);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  /// ينتقل للخانة التالية عند الإدخال، وللسابقة عند الحذف.
  void _onChanged(int i, String value) {
    if (value.isNotEmpty && i < _length - 1) {
      _nodes[i + 1].requestFocus();
    } else if (value.isEmpty && i > 0) {
      _nodes[i - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _verify() async {
    setState(() {
      _isVerifying = true;
      _error = null;
    });
    try {
      await ref.read(authRepositoryProvider).verifyOtp(
            phone: _fullPhone,
            token: _code,
          );
      if (!mounted) return;
      context.go(AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = L10n.of(context).otpInvalid);
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _isResending = true);
    try {
      await ref.read(authRepositoryProvider).sendOtp(_fullPhone);
      if (mounted) _startCountdown();
    } catch (e) {
      if (mounted) setState(() => _error = L10n.of(context).otpResendFailed);
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.otpTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text(l10n.otpEnter, style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: MishwarakColors.lightTextMuted,
                  ),
                  children: [
                    TextSpan(text: l10n.otpSentTo),
                    TextSpan(
                      text: '+967 ${widget.phoneNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: MishwarakColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ═══ خانات الرمز ═══
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  for (var i = 0; i < _length; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        width: 44,
                        height: 60,
                        child: TextField(
                          controller: _controllers[i],
                          focusNode: _nodes[i],
                          autofocus: i == 0,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          style: theme.textTheme.displaySmall,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          decoration: const InputDecoration(counterText: ''),
                          onChanged: (v) => _onChanged(i, v),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),

              // ═══ إعادة الإرسال ═══
              Center(
                child: _secondsLeft > 0
                    ? Text(
                        l10n.otpResendIn(_secondsLeft),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MishwarakColors.lightTextMuted,
                        ),
                      )
                    : TextButton(
                        onPressed: _isResending ? null : _resend,
                        child: Text(l10n.otpResend),
                      ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              const Spacer(),
              ElevatedButton(
                onPressed: _isComplete && !_isVerifying ? _verify : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: theme.dividerColor,
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.confirm),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
