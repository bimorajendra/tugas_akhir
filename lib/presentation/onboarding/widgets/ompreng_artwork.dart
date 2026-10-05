import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_radius.dart';

class OmprengArtwork extends StatelessWidget {
  final int slideIndex;
  final double width;
  final double height;

  const OmprengArtwork({super.key, this.slideIndex = 0, this.width = 240, this.height = 180});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Ilustrasi wadah makan ompreng dengan beberapa kompartemen',
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(color: slideIndex == 1 ? AppColors.accent : AppColors.border, width: slideIndex == 1 ? 1.5 : 1),
            boxShadow: [BoxShadow(color: AppColors.foreground.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4))],
          ),
          child: Row(children: [
            Expanded(flex: 5, child: Container(
              decoration: BoxDecoration(color: AppColors.muted, borderRadius: AppRadius.roundedMd, border: Border.all(color: AppColors.border.withValues(alpha: 0.6))),
              child: Center(child: Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle, border: Border.all(color: slideIndex == 2 ? AppColors.accent : AppColors.border)),
                child: Icon(slideIndex == 2 ? Icons.check_rounded : Icons.restaurant_rounded, size: 20, color: slideIndex == 2 ? AppColors.accent : AppColors.mutedForeground),
              )),
            )),
            const SizedBox(width: 8),
            Expanded(flex: 4, child: Column(children: [
              Expanded(child: _Compartment()),
              const SizedBox(height: 6),
              Expanded(child: _Compartment()),
              const SizedBox(height: 6),
              Expanded(child: _Compartment()),
            ])),
          ]),
        ),
      );
}

class _Compartment extends StatelessWidget {
  const _Compartment();

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: AppColors.muted, borderRadius: AppRadius.roundedSm, border: Border.all(color: AppColors.border.withValues(alpha: 0.6))),
      );
}
