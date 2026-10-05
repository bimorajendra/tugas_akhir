import 'package:flutter/material.dart';
import 'package:gizilens/core/theme/app_colors.dart';
import 'package:gizilens/core/theme/app_spacing.dart';
import 'package:gizilens/core/theme/app_typography.dart';
import 'package:gizilens/presentation/onboarding/widgets/onboarding_slide.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  static const slides = [
    OnboardingSlideData(title: 'Kenali asupanmu dengan lebih mudah', description: 'Pantau makanan dan kandungan gizinya tanpa pencatatan manual yang rumit.', slideIndex: 0),
    OnboardingSlideData(title: 'Cukup foto atau rekam makananmu', description: 'GiziLens membantu membaca makanan dari foto atau video yang kamu kirim.', slideIndex: 1),
    OnboardingSlideData(title: 'Lihat kecukupan gizimu setiap hari', description: 'Bandingkan asupanmu dengan kebutuhan personal dan lihat status gizi secara sederhana.', slideIndex: 2),
  ];

  void _handleNext() {
    if (_currentIndex < slides.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    } else {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() { _pageController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == slides.length - 1;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [
        SizedBox(height: 48, child: Align(alignment: Alignment.centerRight, child: !isLast ? TextButton(key: const Key('onboarding_skip_button'), onPressed: widget.onComplete, child: Text('Lewati', style: AppTypography.button.copyWith(color: AppColors.mutedForeground))) : const SizedBox.shrink())),
        Expanded(child: PageView.builder(key: const Key('onboarding_page_view'), controller: _pageController, itemCount: slides.length, onPageChanged: (index) => setState(() => _currentIndex = index), itemBuilder: (_, index) => OnboardingSlide(data: slides[index]))),
        Padding(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl), child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(slides.length, (index) => AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs), width: _currentIndex == index ? 24 : 8, height: 8, decoration: BoxDecoration(color: _currentIndex == index ? AppColors.accent : AppColors.border, borderRadius: BorderRadius.circular(AppRadius.full))))),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton(key: isLast ? const Key('onboarding_start_button') : const Key('onboarding_next_button'), onPressed: _handleNext, child: Text(isLast ? 'Mulai' : 'Lanjut', style: AppTypography.button.copyWith(fontSize: 15)))),
        ])),
      ])),
    );
  }
}
