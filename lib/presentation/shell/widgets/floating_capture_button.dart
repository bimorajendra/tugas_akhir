import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';

class FloatingCaptureButton extends StatelessWidget {
  final VoidCallback? onTap;

  const FloatingCaptureButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Catat makanan',
        button: true,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          elevation: 4,
          shadowColor: AppColors.accent.withValues(alpha: 0.35),
          child: Ink(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              child: const Center(child: Icon(Icons.camera_alt_rounded, color: AppColors.onAccent, size: 26)),
            ),
          ),
        ),
      );
}
