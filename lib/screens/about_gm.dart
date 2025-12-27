import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';

class AboutGMPage extends StatelessWidget {
  const AboutGMPage({super.key});

  Future<String> loadAboutGM() async {
    return await rootBundle.loadString('assets/text/aboutgm.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EventCard(),
          ),

          const SizedBox(height: 24),
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

  /*
  Future<void> loadRandomQuote() async {
    final text = await rootBundle.loadString('assets/text/quotes.txt');
    final quotes = text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }*/

  @override
  Widget build(BuildContext context) {
    final quotes = [
      "No Persons here! Only pure Presence!",
      "Your Consciousness is Infinite Beyond Boundaries..!",
      "At the Awareness level...You are Total...The Wholeness..!",
      "Better remain Conscious and Know what you are exactly!",
      "When your Consciousness merges with its source..it transcends itself and knows its Eternity Forever!",
      "Non Dual is Immovable, Indescribable...Complete by itself!",
      "Your 'Iam ness' Consciousness is Incomplete at the Personality Level.!",
      "In Non dual there is nothing here other than Me !",
      "Absolute - Non Dual.! There is no division.!",
      "Awareness is the Observer of the Self and its play!",
    ];

    return Container(
      //height: 578,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBFE6E9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "About GM",
            style: TextStyle(
              fontSize: 16,
              height: 1.0,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),

          FutureBuilder<String>(
            future: loadText(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final aboutGM = snapshot.data!;

              const imgUrl =
                  'https://rvevlngiswoduyxwetsb.supabase.co/storage/v1/object/public/quote/quote/GM_Photo.jpeg';

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

                  const SizedBox(height: 16),
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      quotes[Random().nextInt(quotes.length)],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 1,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          aboutGM,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontFamily: 'PlayfairDisplay',
                            // fontWeight: FontWeight.bold,
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
