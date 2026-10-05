import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/core/theme/app_theme.dart';
import 'package:gizilens/presentation/auth/forgot_password_screen.dart';
import 'package:gizilens/presentation/auth/login_screen.dart';
import 'package:gizilens/presentation/auth/register_screen.dart';
import 'package:gizilens/presentation/auth/splash_screen.dart';
import 'package:gizilens/presentation/home/home_screen.dart';
import 'package:gizilens/presentation/onboarding/onboarding_screen.dart';
import 'package:gizilens/presentation/profile/profile_setup_screen.dart';
import 'package:gizilens/features/capture/presentation/screens/camera_capture_screen.dart';
import 'package:gizilens/features/capture/presentation/screens/media_preview_screen.dart';
import 'package:gizilens/features/capture/presentation/screens/permission_denied_screen.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_processing_screen.dart';
import 'package:gizilens/features/analysis/presentation/screens/analysis_result_screen.dart';
import 'package:gizilens/features/history/presentation/screens/food_record_detail_screen.dart';
import 'package:gizilens/features/history/presentation/screens/history_screen.dart';
import 'package:gizilens/features/history/data/mock_history_records.dart';
import 'package:gizilens/features/nutrition_detail/presentation/screens/nutrition_detail_screen.dart';

const _sampleDetectedFoods = [
  DetectedFoodItem(
    id: 'food-1',
    name: 'Nasi Putih',
    portion: 150,
    portionUnit: 'gram',
    calories: 195,
    protein: 4,
    carbs: 43.5,
    fat: 0.4,
    dynamicNutrients: {'Serat': '0.6 g', 'Natrium': '1.5 mg'},
  ),
  DetectedFoodItem(
    id: 'food-2',
    name: 'Ayam Bakar Dada',
    portion: 100,
    portionUnit: 'gram',
    calories: 165,
    protein: 31,
    carbs: 0,
    fat: 3.6,
    dynamicNutrients: {'Kolesterol': '85 mg', 'Kalium': '256 mg'},
  ),
  DetectedFoodItem(
    id: 'food-3',
    name: 'Tumis Buncis Tempe',
    portion: 80,
    portionUnit: 'gram',
    calories: 78,
    protein: 4.2,
    carbs: 6.8,
    fat: 4.1,
    dynamicNutrients: {'Serat': '2.4 g', 'Vitamin A': '180 IU'},
  ),
];

final _sampleFoodRecord = sampleLunchRecord(DateTime.now());

void main() => runApp(const ProviderScope(child: GiziLensApp()));

class GiziLensApp extends StatelessWidget {
  const GiziLensApp({super.key});

  String get _initialRoute {
    final path = Uri.base.path;
    const supportedRoutes = {
      '/',
      '/login',
      '/register',
      '/forgot-password',
      '/onboarding',
      '/profile/setup',
      '/home',
      '/capture',
      '/capture/permission-denied',
      '/capture/preview',
      '/capture/analyzing',
      '/capture/results',
      '/capture/analysis-failed',
      '/nutrition/detail',
      '/history/record-detail',
      '/history',
    };
    return supportedRoutes.contains(path) ? path : '/';
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'GiziLens',
    theme: AppTheme.lightTheme,
    home: Builder(
      builder: (pageContext) => _pageForRoute(pageContext, _initialRoute),
    ),
    routes: {
      '/login': (_) => const LoginScreen(),
      '/register': (_) => const RegisterScreen(),
      '/forgot-password': (_) => const ForgotPasswordScreen(),
      '/onboarding': (_) => Builder(
        builder: (routeContext) => OnboardingScreen(
          onComplete: () =>
              Navigator.of(routeContext).pushReplacementNamed('/profile/setup'),
        ),
      ),
      '/profile/setup': (_) => Builder(
        builder: (routeContext) => ProfileSetupScreen(
          onComplete: () =>
              Navigator.of(routeContext).pushReplacementNamed('/home'),
        ),
      ),
      '/home': (_) => const HomeScreen(userName: 'Budi'),
      '/nutrition/detail': (_) => const NutritionDetailScreen(),
      '/history': (_) => const HistoryScreen(),
      '/history/record-detail': (routeContext) {
        final argument = ModalRoute.of(routeContext)?.settings.arguments;
        return FoodRecordDetailScreen(
          record: argument is FoodRecordDetailData
              ? argument
              : _sampleFoodRecord,
        );
      },
      '/capture': (_) => const CameraCaptureScreen(),
      '/capture/permission-denied': (_) => PermissionDeniedScreen(
        onOpenSettings: () {},
        onPickFromGallery: () {},
      ),
      '/capture/preview': (routeContext) => MediaPreviewScreen(
        mediaPath: 'mock/path/food_capture.jpg',
        onRetake: () =>
            Navigator.of(routeContext).pushReplacementNamed('/capture'),
        onConfirmAnalysis: (_) => Navigator.of(
          routeContext,
        ).pushReplacementNamed('/capture/analyzing'),
      ),
      '/capture/analyzing': (routeContext) => AnalysisProcessingScreen(
        mediaPath: 'mock/path/food_capture.jpg',
        isVideo: false,
        onAnalysisCompleted: () =>
            Navigator.of(routeContext).pushReplacementNamed('/capture/results'),
      ),
      '/capture/results': (routeContext) => _analysisResult(routeContext),
      '/capture/analysis-failed': (routeContext) =>
          _analysisResult(routeContext, isFailure: true),
    },
  );

  Widget _pageForRoute(BuildContext context, String route) {
    switch (route) {
      case '/home':
        return const HomeScreen(userName: 'Budi');
      case '/nutrition/detail':
        return const NutritionDetailScreen();
      case '/history/record-detail':
        return FoodRecordDetailScreen(record: _sampleFoodRecord);
      case '/history':
        return const HistoryScreen();
      case '/capture':
        return const CameraCaptureScreen();
      case '/capture/permission-denied':
        return PermissionDeniedScreen(
          onOpenSettings: () {},
          onPickFromGallery: () {},
        );
      case '/capture/preview':
        return MediaPreviewScreen(
          mediaPath: 'mock/path/food_capture.jpg',
          onRetake: () =>
              Navigator.of(context).pushReplacementNamed('/capture'),
          onConfirmAnalysis: (_) =>
              Navigator.of(context).pushReplacementNamed('/capture/analyzing'),
        );
      case '/capture/analyzing':
        return AnalysisProcessingScreen(
          mediaPath: 'mock/path/food_capture.jpg',
          isVideo: false,
          onAnalysisCompleted: () =>
              Navigator.of(context).pushReplacementNamed('/capture/results'),
        );
      case '/capture/results':
        return _analysisResult(context);
      case '/capture/analysis-failed':
        return _analysisResult(context, isFailure: true);
      default:
        return SplashScreen(
          onProceed: (isBypassed) => Navigator.of(
            context,
          ).pushReplacementNamed(isBypassed ? '/home' : '/onboarding'),
        );
    }
  }

  Widget _analysisResult(BuildContext context, {bool isFailure = false}) {
    return AnalysisResultScreen(
      items: isFailure ? const [] : _sampleDetectedFoods,
      compartmentCount: 3,
      isFailure: isFailure,
      onRetake: () => Navigator.of(context).pushReplacementNamed('/capture'),
      onPickGallery: () =>
          Navigator.of(context).pushReplacementNamed('/capture/preview'),
    );
  }
}
