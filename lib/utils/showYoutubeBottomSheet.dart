import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/youtube_links.dart';

void showYoutubeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "YouTube Resources",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...youtubeLinks.map((item) {
              return ListTile(
                leading: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.red,
                ),
                title: Text(item.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  final uri = Uri.parse(item.url);
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                },
              );
            }).toList(),
          ],
        ),
      );
    },
  );
}
