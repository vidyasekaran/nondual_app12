import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/web_links.dart';

void showWebLinksBottomSheet(BuildContext context) {
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
              "Website & Q&A",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...webLinks.map((item) {
              return ListTile(
                leading: const Icon(Icons.public),
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
