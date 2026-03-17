import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nondual_app/main.dart';
import 'package:nondual_app/utils/loadingIndicator.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _checkForUpdate();
    await _navigateNext();
  }

  Future<void> _navigateNext() async {
    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
      );
    });
  }

  Future<void> _checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // 🔴 Only trigger immediate update if allowed
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }
        // 🟡 Optional: fallback to flexible update
        else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("Update check failed: $e");
    }
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
                Center(
                  child: Text(
                    "GM’s Nondual Teachings",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      letterSpacing: 1.5,
                      color: const Color.fromRGBO(103, 11, 173, 1),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "You Are That.!",
                      speed: const Duration(milliseconds: 60),
                      cursor: "", // removes the blinking cursor
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
}
