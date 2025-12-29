import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final todayPath = 'quote/$date.jpg';

    final supabase = Supabase.instance.client;
    final imageUrl =
        '${supabase.storage.from('quote').getPublicUrl(todayPath)}?t=${DateTime.now().millisecondsSinceEpoch}';

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Quote of the Day",
            style: GoogleFonts.inter(
              fontSize: 20,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D4F1C),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
 AspectRatio(
  aspectRatio: 3 / 2,
  child: ClipRRect(
    child: Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Text(
            "Today's quote image is not available yet",
            textAlign: TextAlign.center,
          ),
        );
      },
    ),
  ),
),
        ],
      ),
    );
  }
}
