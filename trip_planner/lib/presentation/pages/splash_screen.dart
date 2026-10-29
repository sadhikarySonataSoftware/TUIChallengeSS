
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trip_planner/main.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    _navigationTimer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const TripPlannerApp(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child:  Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          'assets/images/tui_logo.webp',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const Positioned(
          top: 8,
          left: -30,
          child: Text(
            'with',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 157, 168, 182),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(width: 16),
    Image.asset(
      'assets/images/heart_stripes.webp',
      width: 60,
      height: 60,
      fit: BoxFit.contain,
    ),
  ],
),
        ),
      ),
    );
  }
}
