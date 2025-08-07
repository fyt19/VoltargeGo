import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voltargego_flutter/presentation/profile/profile_page.dart';
import 'presentation/last_rentals/last_rentals_page.dart';
import 'presentation/login/login_page.dart';
import 'presentation/register/register_page.dart';
import 'presentation/home/home_page.dart';
import 'presentation/list/list_page.dart';
import 'presentation/detail/detail_page.dart';
import 'presentation/reservation/reservation_page.dart';
import 'presentation/payment/payment_page.dart';
import 'presentation/charging/charging_page.dart';
import 'presentation/map/map_page.dart';
import 'presentation/onboarding/onboarding_page.dart';
import 'presentation/onboarding/welcome_page.dart';

class VoltargeGoApp extends StatefulWidget {
  const VoltargeGoApp({super.key});

  @override
  State<VoltargeGoApp> createState() => _VoltargeGoAppState();
}

class _VoltargeGoAppState extends State<VoltargeGoApp> {
  bool _isLoading = true;
  bool _showOnboarding = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

    setState(() {
      _showOnboarding = !onboardingCompleted;
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF00133D),
                  Color(0xFF00D9D9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'VoltargeGo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Color(0xFFF7F7F7),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: _showOnboarding
          ? const OnboardingPage()
          : _isLoggedIn
              ? const HomePage()
              : const WelcomePage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/list': (context) => const ListPage(),
        '/detail': (context) => const DetailPage(),
        '/reservation': (context) => const ReservationPage(),
        '/payment': (context) => const PaymentPage(),
        '/charging': (context) => const ChargingPage(),
        '/map': (context) => const MapPage(),
        '/profile': (context) => const ProfilePage(),
        '/last_rentals': (context) => const LastRentalsPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/welcome': (context) => const WelcomePage(),
      },
    );
  }
}
