import 'package:flutter/material.dart';
import 'package:nondual_app/screens/audo_page.dart';
import 'package:nondual_app/screens/quotepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/adminlongpresstitle.dart';
import '../utils/resourcegrid_nice.dart';
import 'my_page.dart';
import 'about_gm.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF2F2F2),
      backgroundColor: const Color.fromARGB(255, 113, 151, 138),

      //backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: AdminLongPressTitle(),
        centerTitle: true,
        // backgroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: const Color.fromARGB(255, 208, 177, 73),
        scrolledUnderElevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'Downloads') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Downloads"),
                    content: const Text("This feature is work in progress."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Close"),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Downloads',
                child: Text('Downloads'),
              ),
            ],
          ),
        ],
      ),
      body: DefaultTextStyle(
        style: const TextStyle(
          color: Color.fromARGB(255, 16, 12, 1), // ivory
          fontSize: 16,
        ),
        child: IconTheme(
          data: const IconThemeData(
            color: Color.fromARGB(255, 164, 153, 115), // gold
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                QuotePage(),
                AboutGMPage(),

                MyPage(),
                const AllQuotesGallery(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                  child: Text(
                    'Resources Library',
                    style: TextStyle(
                      color: const Color(0xFF121212),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ResourceGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<String>> fetchAllQuoteImages() async {
  final supabase = Supabase.instance.client;

  final files = await supabase.storage.from('quote').list(path: 'allquotes');
  print(files);
  return files
      .where(
        (f) =>
            f.name.endsWith('.jpeg') ||
            f.name.endsWith('.jpg') ||
            f.name.endsWith('.png'),
      )
      .map(
        (f) =>
            supabase.storage.from('quote').getPublicUrl('allquotes/${f.name}'),
      )
      .toList();
}

class AllQuotesGallery extends StatelessWidget {
  const AllQuotesGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchAllQuoteImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No images found'));
        }

        final images = snapshot.data!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(title: const Text('All Quotes')),
            GridView.builder(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true, // 🔑 IMPORTANT
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(images[index], fit: BoxFit.cover);
              },
            ),
          ],
        );
      },
    );
  }
}

class ExploreList extends StatelessWidget {
  const ExploreList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchAllQuoteImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No images found'));
        }

        final images = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
              ),
            );
          },
        );
      },
    );
  }
}

class Quotes extends StatelessWidget {
  final List<String> images;

  const Quotes({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GM's Quotes")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 images per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.asset(images[index]);
        },
      ),
    );
  }
}

class ExploreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ExploreItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2E2839) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Icon(icon, color: isDark ? Colors.white : Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
