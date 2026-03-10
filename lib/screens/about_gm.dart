import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import 'dart:typed_data';

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
  const EventCard({super.key, this.headerImageBytes});

  final Uint8List? headerImageBytes;

  Future<String> loadText() async {
    return await rootBundle.loadString('assets/text/aboutgm.txt');
  }

  @override
  Widget build(BuildContext context) {
    final quotes = [
      "Your Consciousness is Infinite Beyond Boundaries..!\n...GM...",
      "At the Awareness level...You are Total...The Wholeness..!\n...GM...",
      "Better remain Conscious and Know what you are exactly!\n...GM...",
      "When your Consciousness merges with its source..it transcends itself and knows its Eternity Forever!\n...GM...",
      "Non Dual is Unmoving, Indescribable...Complete by itself!\n...GM...",
      "Your 'Iam ness' Consciousness is Incomplete at the Personality Level.!\n...GM...",
      "In Non dual there is nothing here other than Me !\n...GM...",
      "Absolute - Non Dual.! There is no division.!\n...GM...",
      "Awareness is the Observer of the Self and its play!\n...GM...",
      "Awareness Observes.! Consciousness Manifests.! \n...GM...",
      "Truth is Beyond Duality.! Non-dual is Beyond Duality.! Your Destination is Beyond Duality.! \n...GM...",
      "The Observer is beyond space.! Observed movie is in space.! \n...GM...",
      "There are No Persons Ever Here.! It is Consciousness Realizing its Original Nature.! By Being Conscious of itself Inwardly.! \n...GM....",
      "Once you know the need to wake up Totally, You cannot miss to be Wakeful inwardly.! \n...GM...",
      "Once You know that the Real cannot change Itself You remain Undisturbed by Any Happening in Space.!\n...GM...",
      "Your Consciousness is the Source of your Awareness.! \n...GM...",
      "The Observer is already Free from the duality.! \n...GM...",
      "All your sufferings are inside the dream.! Wake up and know.!\n...GM...",
      "Your Consciousness is Prior to Duality.! Identifications are at the Object level, Duality level.! \n...GM...",
      "First know the Unchanging Peace Within to Remain free from The Ever-changing duality.! \n...GM...",
      "You are Never Separate from the Truth.! You are Already the Highest Truth and Always the Highest Truth.!\n...GM...",
      "Simply Observe and Remain Peaceful as None of the Frame in the Screen of Space is Real.! \n...GM...",
      "First you are Conscious of Yourself as ‘I am-ness’.! In your ‘I am-ness’ Consciousness not only your Form But all forms appear Just Now.! \n...GM...",
      "Remain Conscious Inwardly and Wake up from the Moving Duality show Which is Not You.! \n...GM...",
      "Only a Realized Can tell you that In Your Conscious Presence Only Everything Appears, Moves and Disappears.! \n...GM...",
      "Observation is not spontaneous Because it is not a happening.! \n...GM...",
      "Through Peace and Joy Your Consciousness Wakes up.! \n...GM...",
      "But for Your ‘I am-ness’ there is Neither Manifestation Nor any Objects in Space.! \n...GM...",
      "Your Consciousness is Unmoving and Non-dual Prior to Space.! Thoughts are Movements Happening at the duality level in Space.! \n...GM...",
      "Only a Realized knows that your Consciousness is Ignorant about itself By accepting the form to be itself Within Duality.! \n...GM...",
      "When your search is Sincere and Authentic You will Never miss knowing The Absolute Truth Within.! \n...GM...",
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
            " About GM",
            style: GoogleFonts.inter(
              fontSize: 18,
              height: 1.2,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D4F1C),
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

              // const imgUrl = 'assets/images/GM_Photo.png';

              final double imageSize = MediaQuery.of(context).size.width * 0.3;

              return Column(
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: imageSize,
                      height: imageSize,
                      child: headerImageBytes != null
                          ? Image.memory(headerImageBytes!, fit: BoxFit.cover)
                          : Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/GM_Photo.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /*   ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    textColor: const Color(
                      0xFF0D4F1C,
                    ), // Dark green for better readability
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
                        color: const Color(
                          0xFF0D4F1C,
                        ), // Dark green for better readability
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
                            color: const Color(
                              0xFF0D4F1C,
                            ), // Dark green for better readability
                            letterSpacing: 0.2,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),*/
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor:
                            Colors.transparent, // removes default line
                      ),
                      child: ExpansionTile(
                        trailing: Image.asset(
                          "assets/images/down.png",
                          width: 28,
                          height: 28,
                        ),
                        childrenPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),

                        collapsedIconColor: const Color(0xFF0D4F1C),
                        iconColor: const Color(0xFF0D4F1C),

                        title: Text(
                          quotes[Random().nextInt(quotes.length)],
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0D4F1C),
                          ),
                        ),

                        children: [
                          Text(
                            aboutGM,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              height: 1.6,
                              color: const Color(0xFF0D4F1C),
                            ),
                          ),
                        ],
                      ),
                    ),
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
