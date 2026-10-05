import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gizilens/presentation/auth/providers/auth_state_provider.dart';
import 'package:gizilens/presentation/auth/splash_screen.dart';
import 'package:gizilens/presentation/auth/login_screen.dart';
import 'package:gizilens/presentation/auth/register_screen.dart';
import 'package:gizilens/presentation/auth/forgot_password_screen.dart';

void main() {
  group('SplashScreen', () {
    testWidgets('renders wordmark and subtitle', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: SplashScreen())));
      expect(find.text('GiziLens'), findsOneWidget);
      expect(find.text('Pemantauan Gizi & Asupan Personal'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('calls onProceed with bypass state', (tester) async {
      var called = false;
      var bypassed = false;
      await tester.pumpWidget(ProviderScope(
        overrides: [authBypassProvider.overrideWith((ref) => true)],
        child: MaterialApp(home: SplashScreen(
          autoProceedDelay: const Duration(milliseconds: 100),
          onProceed: (value) { called = true; bypassed = value; },
        )),
      ));
      await tester.pump(const Duration(milliseconds: 150));
      expect(called, isTrue);
      expect(bypassed, isTrue);
    });
  });

  group('LoginScreen', () {
    testWidgets('validates empty submission', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LoginScreen())));
      expect(find.text('Selamat datang kembali'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Kata Sandi'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Email wajib diisi'), findsOneWidget);
      expect(find.text('Kata sandi wajib diisi'), findsOneWidget);
    });

    testWidgets('toggles password visibility', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MaterialApp(home: LoginScreen())));
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    });

    testWidgets('submits valid input', (tester) async {
      String? email;
      String? password;
      await tester.pumpWidget(ProviderScope(child: MaterialApp(home: LoginScreen(
        onLogin: (e, p) { email = e; password = p; },
      ))));
      await tester.enterText(find.byKey(const Key('login_email_field')), 'user@gizilens.id');
      await tester.enterText(find.byKey(const Key('login_password_field')), 'secret123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
      await tester.pumpAndSettle();
      expect(email, 'user@gizilens.id');
      expect(password, 'secret123');
    });
  });

  testWidgets('RegisterScreen submits valid payload', (tester) async {
    String? name;
    String? email;
    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: RegisterScreen(
      onRegister: (n, e, p) { name = n; email = e; },
    ))));
    expect(find.text('Buat Akun Baru'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('register_name_field')), 'Ahmad Budi');
    await tester.enterText(find.byKey(const Key('register_email_field')), 'budi@gizilens.id');
    await tester.enterText(find.byKey(const Key('register_password_field')), 'password123');
    await tester.enterText(find.byKey(const Key('register_confirm_password_field')), 'password123');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Buat Akun'));
    await tester.pumpAndSettle();
    expect(name, 'Ahmad Budi');
    expect(email, 'budi@gizilens.id');
  });

  testWidgets('ForgotPasswordScreen confirms submission', (tester) async {
    String? email;
    await tester.pumpWidget(ProviderScope(child: MaterialApp(home: ForgotPasswordScreen(
      onSendInstructions: (value) => email = value,
    ))));
    expect(find.text('Lupa kata sandi?'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('forgot_password_email_field')), 'reset@gizilens.id');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Kirim instruksi'));
    await tester.pumpAndSettle();
    expect(email, 'reset@gizilens.id');
    expect(find.text('Instruksi pemulihan telah dikirim'), findsOneWidget);
  });
}
