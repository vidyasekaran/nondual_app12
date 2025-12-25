import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuotePage extends StatelessWidget {
  const QuotePage({super.key});

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;

    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    //final yesterday = formatDate(today.subtract(const Duration(days: 1)));

    final today_path = 'quote/$date.jpg';

    final supabase = Supabase.instance.client;
    //final imageUrl = supabase.storage.from('quote').getPublicUrl(path);
    final imageUrl =
        '${supabase.storage.from('quote').getPublicUrl(today_path)}?t=${DateTime.now().millisecondsSinceEpoch}';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Quote of the Day",
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              fontFamily: 'PlayfairDisplay',
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 4 / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const Center(child: CircularProgressIndicator());
                },

                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        "Today's quote image is not available yet",
                        textAlign: TextAlign.center,
                      ),
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
