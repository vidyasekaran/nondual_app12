import 'package:flutter/material.dart';
import 'package:nondual_app/model/book.dart';
import 'package:url_launcher/url_launcher.dart';

void showBookLinksBottomSheet(BuildContext context, Book book) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              book.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: book.links.entries.map((entry) {
                return ElevatedButton(
                  onPressed: () async {
                    final uri = Uri.parse(entry.value);
                    if (!await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    )) {
                      throw "Could not open link";
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(), // oval buttons
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: Text(entry.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
