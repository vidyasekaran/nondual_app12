import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class ResourceGrid extends StatelessWidget {
  const ResourceGrid({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = [
      (
        Icons.local_florist_outlined,
        'Satsang - Youtube',
        'https://youtube.com/@teachingsofgm?si=1S7s4WOsly9Z1XlM'
      ),
      (
        Icons.music_note_outlined,
        'Satsang - Spotify',
        'https://open.spotify.com/show/3diTrqSFWQfbpalggpakuO?si=b9c87030fc1d41a2'
      ),
      (
        Icons.help_outline,
        'Q & A',
        'https://youarealreadythat.com/category/question-answers/'
      ),
      (Icons.public, 'Website', 'https://youarealreadythat.com/'),
      (
        Icons.music_video_outlined,
        'NonDual Songs',
        'https://www.youtube.com/@GMNonDualSongs'
      ),
      (Icons.library_books_outlined, 'Buy Book', 'https://amzn.in/d/imXf5hz'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return GestureDetector(
          onTap: () => _launchUrl(resources[index].$3),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F1C27) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    resources[index].$1,
                    size: 30,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                resources[index].$2,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
