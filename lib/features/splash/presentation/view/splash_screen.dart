import 'dart:math';
import 'package:fishy/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/cache_helper.dart';
import '../../../home/presentation/view/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    for (int i = 0; i < 30; i++) {
      _bubbles.add(Bubble(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 30 + 10,
        speed: _random.nextDouble() * 2 + 1,
        delay: _random.nextDouble() * 2,
      ));
    }

    _controller.forward().then((_) async {
      var isFirstTimeOpen = await CacheHelper.getData(key: 'isFirstTimeOpen')?? true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isFirstTimeOpen ? OnboardingView() : HomeView(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ..._bubbles.map((bubble) => AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final progress = _controller.value;
                  final y = bubble.y - (bubble.speed * progress) - bubble.delay;
                  final opacity = (1 - progress).clamp(0.0, 1.0);

                  return Positioned(
                    left: bubble.x * MediaQuery.of(context).size.width,
                    top: y * MediaQuery.of(context).size.height,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: bubble.size,
                        height: bubble.size,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'assets/images/fishy_logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Text(
                  'Fishy',
                  style: GoogleFonts.quicksand(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D47A1), 
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double delay;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
  });
}
