import 'package:flutter/material.dart';
import '../../utils/books_list.dart';

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
