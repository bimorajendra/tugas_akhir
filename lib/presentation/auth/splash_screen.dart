import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/presentation/auth/providers/auth_state_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final Duration autoProceedDelay;
  final void Function(bool isBypassed)? onProceed;

  const SplashScreen({super.key, this.autoProceedDelay = const Duration(milliseconds: 1200), this.onProceed});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.autoProceedDelay, () {
      if (mounted) widget.onProceed?.call(ref.read(authBypassProvider));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.lens_outlined, color: AppColors.onAccent, size: 40),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('GiziLens', style: AppTypography.display),
                const SizedBox(height: AppSpacing.xs),
                Text('Pemantauan Gizi & Asupan Personal', style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.xl),
                const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent))),
              ],
            ),
          ),
        ),
      );
}
