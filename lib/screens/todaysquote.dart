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
  final noQuoteUrl = '';

  @override
  void initState() {
    super.initState();
    _loadTodayQuote();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Today's Quote",
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
            aspectRatio: 4 / 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
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

