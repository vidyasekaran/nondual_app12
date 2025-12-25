import 'package:flutter/material.dart';
import 'package:nondual_app/screens/audio.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    /* return SingleChildScrollView(
      //padding: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AudioCard(
            title: "GM About Observer",
            audioAsset: "/audio/neutral-observer-v1.mp3",
          ),
          // const SizedBox(height: 12),
        ],
      ),
    );*/
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.5), // 👈 background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            "GMs Satsang Audios : ",
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily: 'TimesNewRoman',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          AudioCard(
            title: "GM About Thoughts",
            audioAsset: "/audio/ilnoor-thoughts-v3.mp3",
          ),
          const SizedBox(height: 20),
          AudioCard(
            title: "GM About Observer",
            audioAsset: "/audio/neutral-observer-v1.mp3",
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
