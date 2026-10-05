import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/domain/models/user_profile.dart';
import 'package:gizilens/presentation/profile/providers/profile_form_provider.dart';
import 'package:gizilens/presentation/profile/widgets/profile_text_field.dart';

class ProfileSetupScreen extends ConsumerWidget {
  final VoidCallback? onComplete;

  const ProfileSetupScreen({super.key, this.onComplete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileFormProvider);
    final notifier = ref.read(profileFormProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Lengkapi profilmu', style: AppTypography.headingLg),
        const SizedBox(height: AppSpacing.sm),
        Text('Data ini digunakan untuk menyesuaikan target kebutuhan gizimu.', style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground)),
        const SizedBox(height: AppSpacing.xl),
        ProfileTextField(label: 'Usia', suffixText: 'tahun', hintText: '25', inputKey: const Key('profile_age_field'), errorText: state.ageError, onChanged: notifier.setAge),
        const SizedBox(height: AppSpacing.md),
        Text('Jenis Kelamin', style: AppTypography.label),
        const SizedBox(height: AppSpacing.xs),
        Row(children: [
          Expanded(child: _GenderOptionCard(label: 'Laki-laki', isSelected: state.gender == Gender.male, onTap: () => notifier.setGender(Gender.male))),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _GenderOptionCard(label: 'Perempuan', isSelected: state.gender == Gender.female, onTap: () => notifier.setGender(Gender.female))),
        ]),
        const SizedBox(height: AppSpacing.md),
        ProfileTextField(label: 'Tinggi Badan', suffixText: 'cm', hintText: '170', inputKey: const Key('profile_height_field'), errorText: state.heightError, onChanged: notifier.setHeight),
        const SizedBox(height: AppSpacing.md),
        ProfileTextField(label: 'Berat Badan', suffixText: 'kg', hintText: '65', inputKey: const Key('profile_weight_field'), errorText: state.weightError, onChanged: notifier.setWeight),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(width: double.infinity, height: 52, child: ElevatedButton(onPressed: state.isSubmitting ? null : () async {
          await notifier.submit();
          if (context.mounted && ref.read(profileFormProvider).isSuccess) onComplete?.call();
        }, child: state.isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.onAccent))) : Text('Simpan & Lanjutkan', style: AppTypography.button))),
        if (state.isSuccess) const Center(child: SizedBox(key: Key('profile_setup_success_indicator'), height: 0, width: 0)),
      ]))),
    );
  }
}

class _GenderOptionCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOptionCard({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: AppRadius.roundedMd,
        child: Container(
          height: 52,
          decoration: BoxDecoration(color: isSelected ? AppColors.muted : AppColors.surface, borderRadius: AppRadius.roundedMd, border: Border.all(color: isSelected ? AppColors.accent : AppColors.border, width: isSelected ? 1.5 : 1)),
          alignment: Alignment.center,
          child: Text(label, style: AppTypography.bodyMd.copyWith(color: isSelected ? AppColors.accent : AppColors.foreground, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
        ),
      );
}
