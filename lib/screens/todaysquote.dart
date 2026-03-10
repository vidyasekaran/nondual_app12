import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TodaysQuote extends StatefulWidget {
  const TodaysQuote({super.key});

  @override
  State<TodaysQuote> createState() => _TodaysQuoteState();
}

class _TodaysQuoteState extends State<TodaysQuote> {
  String? imageUrl;
  bool isLoading = true;
  final noQuoteUrl = 'assets/images/quotes/1.jpeg';

  @override
  void initState() {
    super.initState();
    _loadTodayQuote();
  }
  /*
  Future<void> _loadTodayQuote() async {
    try {
      final supabase = Supabase.instance.client;
      
      // Try different image extensions for "todayquote"
      final possibleExtensions = ['.jpg', '.jpeg', '.png','gif','webp'];
      String? selectedPath;
      
      // Check which extension exists
      final files = await supabase.storage.from('quote').list(path: 'quote');
      
      for (var ext in possibleExtensions) {
        final path = 'quote/todayquote$ext';
        final fileExists = files.any((f) => f.name == 'todayquote$ext');
        
        if (fileExists) {
          selectedPath = path;
          break;
        }
      }
      
      // If no file found with extensions, try without extension
      if (selectedPath == null) {
        final fileExists = files.any((f) => f.name == 'todayquote');
        if (fileExists) {
          selectedPath = 'quote/todayquote';
        }
      }

      if (selectedPath != null) {
        // Use cache-busting timestamp to ensure fresh image when overwritten
        final url =
            '${supabase.storage.from('quote').getPublicUrl(selectedPath)}?t=${DateTime.now().millisecondsSinceEpoch}';
        setState(() {
          imageUrl = url;
          isLoading = false;
        });
      } else {
        setState(() {
          imageUrl = null;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        imageUrl = null;
        isLoading = false;
      });
    }
  }*/

  /*
Bucket & Folder name is → quote So final path: quote/quote/todayquote.jpg

*/

  Future<void> _loadTodayQuote() async {
    try {
      final supabase = Supabase.instance.client;

      // List files inside folder "quote"
      final files = await supabase.storage.from('quote').list(path: 'quote');

      // Find file that starts with "todayquote"
      final file = files.firstWhere(
        (f) => f.name.startsWith('todayquote'),
        orElse: () => throw Exception('File not found'),
      );

      final selectedPath = 'quote/${file.name}';

      final publicUrl = supabase.storage
          .from('quote')
          .getPublicUrl(selectedPath);

      setState(() {
        imageUrl = '$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        imageUrl = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "🌼 GM 's Eternal Quotes",
            style: GoogleFonts.inter(
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D4F1C),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        // Show fallback image on error
                        return Center(
                          child: Image.asset(
                            noQuoteUrl,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      noQuoteUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
