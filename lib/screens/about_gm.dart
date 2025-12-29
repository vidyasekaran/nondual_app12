import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class AboutGMPage extends StatelessWidget {
  const AboutGMPage({super.key});

  Future<String> loadAboutGM() async {
    return await rootBundle.loadString('assets/text/aboutgm.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: EventCard(),
          ),

          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({super.key});

  Future<String> loadText() async {
    return await rootBundle.loadString('assets/text/aboutgm.txt');
  }

  @override
  Widget build(BuildContext context) {
    final quotes = [
      "No Persons here! Only pure Presence!\n .GM..",
      "No events here! Only pure Presence!\n..GM..",
      "No time here! Only pure Presence!\n..GM..",
      "No objects here! Only pure Presence!\n..GM..",
      "Your Consciousness is Infinite Beyond Boundaries..!\n..GM..",
      "At the Awareness level...You are Total...The Wholeness..!\n..GM..",
      "Better remain Conscious and Know what you are exactly!\n..GM..",
      "When your Consciousness merges with its source..it transcends itself and knows its Eternity Forever!\n..GM..",
      "Non Dual is Immovable, Indescribable...Complete by itself!\n..GM..",
      "Your 'Iam ness' Consciousness is Incomplete at the Personality Level.!\n..GM..",
      "In Non dual there is nothing here other than Me !\n..GM..",
      "Absolute - Non Dual.! There is no division.!\n..GM..",
      "Awareness is the Observer of the Self and its play!\n..GM..",
    ];

    return Container(
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
            "About GM",
            style: GoogleFonts.inter(
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D4F1C), // Dark green for better readability
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),

          FutureBuilder<String>(
            future: loadText(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final aboutGM = snapshot.data!;

              const imgUrl =
                  'https://rvevlngiswoduyxwetsb.supabase.co/storage/v1/object/public/quote/quote/GM_Photo.png';

              final double imageSize = MediaQuery.of(context).size.width * 0.3;

              return Column(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: Image.network(
                        imgUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.person, size: 40),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
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
                      quotes[Random().nextInt(quotes.length)],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D4F1C), // Dark green for better readability
                        letterSpacing: 0.3,
                      ),
                    ),

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          aboutGM,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.6,
                            color: const Color(0xFF0D4F1C), // Dark green for better readability
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
