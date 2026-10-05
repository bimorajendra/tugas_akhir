import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';

class RegisterScreen extends StatefulWidget {
  final void Function(String name, String email, String password)? onRegister;
  final VoidCallback? onNavigateToLogin;

  const RegisterScreen({super.key, this.onRegister, this.onNavigateToLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() { _name.dispose(); _email.dispose(); _password.dispose(); _confirm.dispose(); super.dispose(); }

  InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint, hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground), suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14), filled: true, fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
      );

  Widget _field(String label, TextEditingController controller, String key, String hint, String? Function(String?) validator, {TextInputType? keyboardType, bool obscureText = false, Widget? suffix}) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(label, style: AppTypography.caption.copyWith(color: AppColors.foreground)),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(key: Key(key), controller: controller, keyboardType: keyboardType, obscureText: obscureText, style: AppTypography.bodyMd, decoration: _decoration(hint, suffix: suffix), validator: validator),
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
          child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Buat Akun Baru', style: AppTypography.headingLg),
            const SizedBox(height: AppSpacing.xs),
            Text('Mulai pantau kecukupan gizimu dengan mudah.', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground)),
            const SizedBox(height: AppSpacing.lg),
            _field('Nama Lengkap', _name, 'register_name_field', 'Nama lengkapmu', (v) => v == null || v.trim().isEmpty ? 'Nama lengkap wajib diisi' : null),
            const SizedBox(height: AppSpacing.md),
            _field('Email', _email, 'register_email_field', 'nama@email.com', (v) => v == null || v.trim().isEmpty ? 'Email wajib diisi' : (!v.contains('@') ? 'Format email tidak valid' : null), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: AppSpacing.md),
            _field('Kata Sandi', _password, 'register_password_field', 'Minimal 8 karakter', (v) => v == null || v.length < 8 ? 'Kata sandi minimal 8 karakter' : null, obscureText: _obscure, suffix: IconButton(tooltip: 'Tampilkan kata sandi', icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined), onPressed: () => setState(() => _obscure = !_obscure))),
            const SizedBox(height: AppSpacing.md),
            _field('Konfirmasi Kata Sandi', _confirm, 'register_confirm_password_field', 'Ulangi kata sandi', (v) => v != _password.text ? 'Konfirmasi kata sandi tidak cocok' : null, obscureText: true),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(height: 48, child: ElevatedButton(onPressed: () { if (_formKey.currentState?.validate() ?? false) widget.onRegister?.call(_name.text.trim(), _email.text.trim(), _password.text); }, child: Text('Buat Akun', style: AppTypography.button))),
            const SizedBox(height: AppSpacing.md),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Sudah punya akun? ', style: AppTypography.bodySm), TextButton(onPressed: widget.onNavigateToLogin, child: Text('Masuk', style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600)))])
          ])),
        )),
      );
}
