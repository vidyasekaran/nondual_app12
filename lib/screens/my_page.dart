import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  Future<String> loadTeaching1() async {
    return await rootBundle.loadString('assets/text/teaching1.txt');
  }

  Future<String> loadTeaching2() async {
    return await rootBundle.loadString('assets/text/teaching2.txt');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([loadTeaching1(), loadTeaching2()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final teaching1 = snapshot.data![0];
        final teaching2 = snapshot.data![1];

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFC8E6C9), // Slightly darker green
                        const Color(0xFFB8D9BA), // Even slightly darker for depth
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(-3, -3),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Core Teachings of GM",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0D4F1C), // Dark green for better readability
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 28),

                      ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        textColor: const Color(0xFF0D4F1C), // Dark green for better readability
                        iconColor: const Color(0xFF0D4F1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          "1. IAM THE SOURCE OF ALL.!",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D4F1C), // Dark green for better readability
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.left,
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              teaching1,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF0D4F1C), // Dark green for better readability
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),

                      // Teaching 2 (Expandable Tile)
                      ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        textColor: const Color(0xFF0D4F1C), // Dark green for better readability
                        iconColor: const Color(0xFF0D4F1C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          "2. STILLNESS IS THE WAY TO THE SUPREME.!",
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D4F1C), // Dark green for better readability
                            letterSpacing: 0.3,
                          ),
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Text(
                              teaching2,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                height: 1.6,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF0D4F1C), // Dark green for better readability
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
