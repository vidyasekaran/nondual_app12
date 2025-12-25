import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart' show rootBundle;

class AboutGMPage extends StatelessWidget {
  const AboutGMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //  Text("About GM", style: Theme.of(context).textTheme.titleMedium),
          // FOREGROUND BOX
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: EventCard(),
          ),

          const SizedBox(height: 24),

          /*       Text(
            "About GM",
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),
          FutureBuilder(
            future: loadText(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              const imgUrl =
                  'https://rvevlngiswoduyxwetsb.supabase.co/storage/v1/object/public/quote/quote/GM_Photo.jpeg';

              final double imageSize = MediaQuery.of(context).size.width * 0.3;

              return Column(
                children: [
                  Center(
                    child: ClipOval(
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
                              child: Icon(Icons.person, size: 30),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  //Text(snapshot.data!, textAlign: TextAlign.center),
                  Text(
                    snapshot.data!,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
  */
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
    return Container(
      height: 578,
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

                  Text(
                    snapshot.data!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: 'PlayfairDisplay',
                      fontWeight: FontWeight.w500,
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
