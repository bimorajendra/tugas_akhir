import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final void Function(String email)? onSendInstructions;
  final VoidCallback? onBackToLogin;

  const ForgotPasswordScreen({super.key, this.onSendInstructions, this.onBackToLogin});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  bool _sent = false;

  @override
  void dispose() { _email.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(leading: IconButton(tooltip: 'Kembali', icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: widget.onBackToLogin ?? () => Navigator.of(context).maybePop())),
        body: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Lupa kata sandi?', style: AppTypography.headingLg),
            const SizedBox(height: AppSpacing.xs),
            Text('Masukkan email terdaftar untuk menerima instruksi pemulihan.', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground)),
            const SizedBox(height: AppSpacing.xl),
            if (_sent) ...[
              Container(padding: const EdgeInsets.all(AppSpacing.md), decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.accent.withAlpha(50)), borderRadius: AppRadius.roundedMd), child: Text('Instruksi pemulihan telah dikirim', style: AppTypography.bodyMd.copyWith(color: AppColors.foreground))),
              const SizedBox(height: AppSpacing.lg),
            ],
            Text('Email', style: AppTypography.caption.copyWith(color: AppColors.foreground)),
            const SizedBox(height: AppSpacing.xs),
            TextFormField(key: const Key('forgot_password_email_field'), controller: _email, keyboardType: TextInputType.emailAddress, style: AppTypography.bodyMd, decoration: InputDecoration(hintText: 'nama@email.com', filled: true, fillColor: AppColors.surface, contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14), border: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)), enabledBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.border)), focusedBorder: OutlineInputBorder(borderRadius: AppRadius.roundedMd, borderSide: const BorderSide(color: AppColors.accent, width: 1.5))), validator: (v) => v == null || v.trim().isEmpty ? 'Email wajib diisi' : (!v.contains('@') ? 'Format email tidak valid' : null)),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(height: 48, child: ElevatedButton(onPressed: () { if (_formKey.currentState?.validate() ?? false) { widget.onSendInstructions?.call(_email.text.trim()); setState(() => _sent = true); } }, child: Text('Kirim instruksi', style: AppTypography.button))),
          ])),
        )),
      );
}
