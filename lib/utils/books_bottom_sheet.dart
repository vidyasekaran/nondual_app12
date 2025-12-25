import 'package:flutter/material.dart';
import '../../data/books_data.dart';
import '../../utils/books_list.dart';

import 'package:url_launcher/url_launcher.dart';

class BooksBottomSheet {
  /// Entry point
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const BooksListView(),
    );
  }
}
