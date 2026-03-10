import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nondual_app/main.dart';
import 'package:nondual_app/utils/loadingIndicator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Wallpaper
          Positioned.fill(
            child: Image.asset(
              'assets/images/wallpaper1.png',
              fit: BoxFit.cover,
            ),
          ),

          // Optional: light white overlay to make text readable
          /*Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.85)),
          ),*/

          // Centered Content (text + animation)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // First Line (Static)
                Text(
                  "GM’s Nondual Teachings",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    letterSpacing: 1.5,
                    color: const Color.fromRGBO(103, 11, 173, 1),
                  ),
                ),

                const SizedBox(height: 20),

                // Second Line (Letter by Letter)
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "You Are That...",
                      speed: const Duration(milliseconds: 120),
                      textStyle: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(90, 7, 138, 1),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // First Line (Static)
            const Text(
              "GM’s Nondual Teachings",
              style: TextStyle(
                fontSize: 32,
                letterSpacing: 1.5,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // Second Line (Letter by Letter)
            AnimatedTextKit(
              isRepeatingAnimation: false,
              animatedTexts: [
                TypewriterAnimatedText(
                  "You Are That",
                  speed: const Duration(milliseconds: 120),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }*/
}
