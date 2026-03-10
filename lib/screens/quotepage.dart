import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String? imageUrl;
  bool isLoading = true;
  final noQuoteUrl = '';
  List<String> triedPaths = []; // Track tried paths to avoid infinite loops
  List<String> availableImageFiles = []; // Store available image files

  @override
  void initState() {
    super.initState();
    _loadQuoteImage();
  }

  Future<void> _loadQuoteImage({bool retryOnError = false}) async {
    try {
      final supabase = Supabase.instance.client;
      final today = DateTime.now();
      final date =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final todayPath = 'quote/$date.jpg';
      final todayFileName = '$date.jpg';

      // List all files in the quote folder
      final files = await supabase.storage.from('quote').list(path: 'quote');

      // Filter for image files
      final imageFiles = files
          .where((f) =>
              (f.name.endsWith('.jpeg') ||
                  f.name.endsWith('.jpg') ||
                  f.name.endsWith('.png')) &&
              !f.name.startsWith('.')) // Exclude hidden files
          .toList();

      // Store available image files for retry logic
      availableImageFiles = imageFiles.map((f) => 'quote/${f.name}').toList();

      String? selectedPath;

      // Check if today's image exists
      final todayFileExists = imageFiles.any((f) => f.name == todayFileName);

      if (todayFileExists && !retryOnError) {
        // Use today's image (only if not retrying after error)
        selectedPath = todayPath;
      } else if (imageFiles.isNotEmpty) {
        // Get the latest uploaded image (sort by name descending, which works for date-based names)
        imageFiles.sort((a, b) => b.name.compareTo(a.name));

        
        
        // Find the first image that hasn't been tried yet
        for (var file in imageFiles) {
          final path = 'quote/${file.name}';
          if (!triedPaths.contains(path)) {
            selectedPath = path;
            break;
          }
        }
        
        // If all images have been tried, use the latest one anyway
        if (selectedPath == null && imageFiles.isNotEmpty) {
          selectedPath = 'quote/${imageFiles.first.name}';
        }
      }

      if (selectedPath != null) {
        // Track this path as tried
        if (!triedPaths.contains(selectedPath)) {
          triedPaths.add(selectedPath);
        }
        
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
            "Quote of the Day",
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
            aspectRatio: 4 / 3, // previously 3/2
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
                            // Retry loading the latest image from Supabase
                            // Check if there are more images available to try
                            final hasMoreImages = availableImageFiles
                                .any((path) => !triedPaths.contains(path));
                            
                            if (mounted && hasMoreImages) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _loadQuoteImage(retryOnError: true);
                                }
                              });
                              // Show loading indicator while retrying
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            // If no more images to try, show fallback
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
