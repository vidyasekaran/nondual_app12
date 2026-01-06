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

    final noQuoteUrl = 'assets/images/quote.jpeg';

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
              borderRadius: BorderRadius.circular(12),
              child: GestureDetector(
                onTap: () {
                  _showImageViewer(
                    context,
                    [imageUrl], // 👈 pass as list
                    0, // 👈 first (and only) image
                  );
                },
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      /*  child: Text(
                      "Today's quote image is not available yet",
                      textAlign: TextAlign.center,
                    ),*/
                      child: Image.network(
                        noQuoteUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showImageViewer(
  BuildContext context,
  List<String> images,
  int initialIndex,
) {
  showDialog(
    context: context,
    barrierColor: Colors.black,
    builder: (_) => Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Image.network(
                    images[index],
                    key: ValueKey(images[index]),
                    fit: BoxFit.contain,
                    gaplessPlayback: false,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              );
            },
          ),

          // Close button
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    ),
  );
}
