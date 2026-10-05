import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/presentation/onboarding/widgets/ompreng_artwork.dart';

class OnboardingSlideData {
  final String title;
  final String description;
  final int slideIndex;

  const OnboardingSlideData({required this.title, required this.description, required this.slideIndex});
}

class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Spacer(flex: 2),
          OmprengArtwork(slideIndex: data.slideIndex),
          const Spacer(flex: 2),
          Text(data.title, textAlign: TextAlign.center, style: AppTypography.headingLg.copyWith(color: AppColors.foreground, height: 1.25)),
          const SizedBox(height: AppSpacing.md),
          Text(data.description, textAlign: TextAlign.center, style: AppTypography.bodyMd.copyWith(color: AppColors.mutedForeground, height: 1.5)),
          const Spacer(flex: 3),
        ]),
      );
}
