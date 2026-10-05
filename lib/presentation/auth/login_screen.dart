import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';

class LoginScreen extends StatefulWidget {
  final void Function(String email, String password)? onLogin;
  final VoidCallback? onNavigateToRegister;
  final VoidCallback? onNavigateToForgotPassword;
  final VoidCallback? onBypassAuth;

  const LoginScreen({super.key, this.onLogin, this.onNavigateToRegister, this.onNavigateToForgotPassword, this.onBypassAuth});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint, {Widget? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.accent, width: 1.5)),
      );

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin?.call(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                const SizedBox(height: AppSpacing.xl),
                Text('Selamat datang kembali', style: AppTypography.headingLg),
                const SizedBox(height: AppSpacing.xs),
                Text('Masuk untuk melanjutkan pemantauan gizimu.', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground)),
                const SizedBox(height: AppSpacing.xl),
                Text('Email', style: AppTypography.caption.copyWith(color: AppColors.foreground)),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  key: const Key('login_email_field'), controller: _emailController, keyboardType: TextInputType.emailAddress,
                  style: AppTypography.bodyMd, decoration: _decoration('nama@email.com'),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Email wajib diisi' : (!value.contains('@') ? 'Format email tidak valid' : null),
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Kata Sandi', style: AppTypography.caption.copyWith(color: AppColors.foreground)),
                const SizedBox(height: AppSpacing.xs),
                TextFormField(
                  key: const Key('login_password_field'), controller: _passwordController, obscureText: _obscurePassword,
                  style: AppTypography.bodyMd,
                  decoration: _decoration('••••••••', suffix: IconButton(
                    tooltip: _obscurePassword ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
                    icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.mutedForeground),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  )),
                  validator: (value) => value == null || value.isEmpty ? 'Kata sandi wajib diisi' : null,
                ),
                Align(alignment: Alignment.centerRight, child: TextButton(onPressed: widget.onNavigateToForgotPassword, child: Text('Lupa kata sandi?', style: AppTypography.bodySm.copyWith(color: AppColors.accent)))),
                const SizedBox(height: AppSpacing.md),
                SizedBox(height: 48, child: ElevatedButton(onPressed: _submit, child: Text('Masuk', style: AppTypography.button))),
                const SizedBox(height: AppSpacing.md),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('Belum punya akun? ', style: AppTypography.bodySm),
                  TextButton(onPressed: widget.onNavigateToRegister, child: Text('Daftar', style: AppTypography.bodySm.copyWith(color: AppColors.accent, fontWeight: FontWeight.w600))),
                ]),
                if (widget.onBypassAuth != null)
                  TextButton(onPressed: widget.onBypassAuth, child: Text('Lanjut tanpa akun', style: AppTypography.bodySm.copyWith(color: AppColors.mutedForeground))),
              ]),
            ),
          ),
        ),
      );
}
