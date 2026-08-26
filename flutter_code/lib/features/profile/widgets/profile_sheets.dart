// ═══════════════════════════════════════════════════════════════
// profile_sheets.dart - نوافذ تحرير الملف الشخصي والعناوين والطوارئ
// ═══════════════════════════════════════════════════════════════
// كانت صفوف شاشة الملف الشخصي كلها `onTap: () {}`، ودوال الكتابة في
// `ProfileRepository` بلا مستدعٍ واحد. هذه النوافذ تصل الاثنين.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../data/profile_repository.dart';

/// يفتح نافذة سفلية بارتفاع يتجنّب لوحة المفاتيح.
Future<T?> _sheet<T>(BuildContext context, WidgetBuilder builder) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => Padding(
      // بدون هذا تختفي الحقول خلف لوحة المفاتيح.
      padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
      child: builder(ctx),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// تعديل الاسم والبريد
// ═══════════════════════════════════════════════════════════════
Future<void> showEditProfileSheet(BuildContext context, WidgetRef ref) {
  return _sheet(context, (_) => _EditProfileSheet(ref: ref));
}

class _EditProfileSheet extends StatefulWidget {
  final WidgetRef ref;
  const _EditProfileSheet({required this.ref});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.ref.read(userProfileProvider).valueOrNull;
    _name = TextEditingController(text: profile?.fullName ?? '');
    _email = TextEditingController(text: profile?.email ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final l10n = L10n.of(context);
    try {
      await widget.ref.read(profileRepositoryProvider).updateProfile(
            fullName: _name.text.trim(),
            email: _email.text.trim(),
          );
      widget.ref.invalidate(userProfileProvider);
      if (!mounted) return;
      Navigator.pop(context);
      _toast(context, l10n.profileUpdated);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(context, l10n.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final phone = widget.ref.watch(userProfileProvider).valueOrNull?.phone;

    return _SheetBody(
      title: l10n.editProfile,
      saving: _saving,
      onSave: _save,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.fullNameLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: l10n.emailLabel),
              // البريد اختياري، لكن إن كُتب فليكن صالحاً.
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return null;
                return _emailPattern.hasMatch(value) ? null : l10n.emailInvalid;
              },
            ),
            if (phone != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: MishwarakColors.lightTextMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.phoneNotEditable,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: MishwarakColors.lightTextMuted,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// فحص بنيوي بسيط — التحقّق الحقيقي يتم بإرسال رسالة تأكيد.
final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

// ═══════════════════════════════════════════════════════════════
// إضافة / تعديل عنوان محفوظ
// ═══════════════════════════════════════════════════════════════
Future<void> showSavedPlaceSheet(
  BuildContext context,
  WidgetRef ref, {
  SavedPlace? existing,
}) {
  return _sheet(context, (_) => _PlaceSheet(ref: ref, existing: existing));
}

class _PlaceSheet extends StatefulWidget {
  final WidgetRef ref;
  final SavedPlace? existing;

  const _PlaceSheet({required this.ref, this.existing});

  @override
  State<_PlaceSheet> createState() => _PlaceSheetState();
}

class _PlaceSheetState extends State<_PlaceSheet> {
  late final TextEditingController _name;
  late final TextEditingController _address;
  late String _label;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _address = TextEditingController(text: widget.existing?.address ?? '');
    _label = widget.existing?.label ?? 'home';
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final l10n = L10n.of(context);
    final repo = widget.ref.read(profileRepositoryProvider);
    final existing = widget.existing;

    try {
      if (existing == null) {
        await repo.addSavedPlace(
          label: _label,
          name: _name.text.trim(),
          address: _address.text.trim(),
          // الإحداثيات تُملأ لاحقاً من شاشة البحث عند اختيار الوجهة؛
          // العنوان النصّي وحده كافٍ للحفظ.
          lat: 0,
          lng: 0,
        );
      } else {
        await repo.updateSavedPlace(
          id: existing.id,
          label: _label,
          name: _name.text.trim(),
          address: _address.text.trim(),
        );
      }
      widget.ref.invalidate(savedPlacesProvider);
      if (!mounted) return;
      Navigator.pop(context);
      _toast(context, l10n.placeSaved);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(context, l10n.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    final kinds = <(String, String, IconData)>[
      ('home', l10n.placeKindHome, Icons.home_outlined),
      ('work', l10n.placeKindWork, Icons.work_outline),
      ('other', l10n.placeKindOther, Icons.place_outlined),
    ];

    return _SheetBody(
      title: widget.existing == null ? l10n.addPlaceTitle : l10n.editPlaceTitle,
      saving: _saving,
      onSave: _save,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 8,
              children: [
                for (final (value, label, icon) in kinds)
                  ChoiceChip(
                    avatar: Icon(icon, size: 16),
                    label: Text(label),
                    selected: _label == value,
                    onSelected: (_) => setState(() => _label = value),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.placeNameLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: l10n.placeAddressLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// إضافة / تعديل جهة اتصال طوارئ
// ═══════════════════════════════════════════════════════════════
Future<void> showEmergencyContactSheet(
  BuildContext context,
  WidgetRef ref, {
  EmergencyContact? existing,
}) {
  return _sheet(context, (_) => _ContactSheet(ref: ref, existing: existing));
}

class _ContactSheet extends StatefulWidget {
  final WidgetRef ref;
  final EmergencyContact? existing;

  const _ContactSheet({required this.ref, this.existing});

  @override
  State<_ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends State<_ContactSheet> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.existing?.name ?? '');
    _phone = TextEditingController(text: widget.existing?.phone ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final l10n = L10n.of(context);
    final repo = widget.ref.read(profileRepositoryProvider);
    final existing = widget.existing;

    try {
      if (existing == null) {
        await repo.addEmergencyContact(
          name: _name.text.trim(),
          phone: _phone.text.trim(),
        );
      } else {
        await repo.updateEmergencyContact(
          id: existing.id,
          name: _name.text.trim(),
          phone: _phone.text.trim(),
        );
      }
      widget.ref.invalidate(emergencyContactsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      _toast(context, l10n.contactSaved);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast(context, l10n.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return _SheetBody(
      title: widget.existing == null
          ? l10n.addContactTitle
          : l10n.editContactTitle,
      saving: _saving,
      onSave: _save,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: l10n.contactNameLabel),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
              ],
              decoration: InputDecoration(
                labelText: l10n.contactPhoneLabel,
                hintText: '+967 77 123 4567',
              ),
              // 9 خانات هي الحد الأدنى لرقم يمني محلي.
              validator: (v) {
                final digits = (v ?? '').replaceAll(RegExp(r'[^0-9]'), '');
                if (digits.isEmpty) return l10n.fieldRequired;
                return digits.length >= 9 ? null : l10n.phoneInvalid;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// تأكيد الحذف
// ═══════════════════════════════════════════════════════════════
Future<bool> confirmDelete(BuildContext context, String message) async {
  final l10n = L10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: MishwarakColors.danger,
            minimumSize: const Size(0, 44),
          ),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

// ─────────────── هيكل مشترك للنوافذ ───────────────
class _SheetBody extends StatelessWidget {
  final String title;
  final Widget child;
  final bool saving;
  final VoidCallback onSave;

  const _SheetBody({
    required this.title,
    required this.child,
    required this.saving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = L10n.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 16),
          child,
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saving ? null : onSave,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: theme.dividerColor,
            ),
            child: saving
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
