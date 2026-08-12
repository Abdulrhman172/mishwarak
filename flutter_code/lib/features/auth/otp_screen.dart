// ═══════════════════════════════════════════════════════════════
// otp_screen.dart - إدخال رمز التحقق (4 خانات) مع عدّاد إعادة الإرسال
// ═══════════════════════════════════════════════════════════════
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const _length = 4;

  final _controllers = List.generate(_length, (_) => TextEditingController());
  final _nodes = List.generate(_length, (_) => FocusNode());

  int _secondsLeft = 30;
  Timer? _timer;

  String get _code => _controllers.map((c) => c.text).join();
  bool get _isComplete => _code.length == _length;

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

  void _verify() {
    // TODO: التحقق من الرمز عبر الـ API
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('رمز التحقق')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Text('أدخل الرمز', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: MishwarakColors.lightTextMuted,
                  ),
                  children: [
                    const TextSpan(text: 'تم إرسال رمز مكوّن من 4 أرقام إلى '),
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
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: SizedBox(
                        width: 60,
                        height: 68,
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
                        'إعادة الإرسال بعد $_secondsLeft ثانية',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: MishwarakColors.lightTextMuted,
                        ),
                      )
                    : TextButton(
                        onPressed: _startCountdown,
                        child: const Text('إعادة إرسال الرمز'),
                      ),
              ),

              const Spacer(),
              ElevatedButton(
                onPressed: _isComplete ? _verify : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: theme.dividerColor,
                ),
                child: const Text('تأكيد'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
