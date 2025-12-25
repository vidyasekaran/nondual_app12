import 'package:flutter/material.dart';
import 'package:nondual_app/data/books_data.dart';
import 'package:nondual_app/model/book.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: unused_element
class BooksListView extends StatelessWidget {
  const BooksListView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Select a Book",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...books.map(
            (book) => ListTile(
              leading: Image.asset(book.image, width: 40),
              title: Text(book.title),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                _showBookLinks(context, book);
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _showBookLinks(BuildContext context, Book book) {
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
              children: book.links.entries
                  .map(
                    (entry) => ElevatedButton(
                      onPressed: () async {
                        final uri = Uri.parse(entry.value);
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(), // oval buttons
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(entry.key),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
