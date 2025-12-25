import 'package:flutter/material.dart';
import 'package:nondual_app/data/books_data.dart';
import 'package:nondual_app/data/youtube_links.dart';
import 'package:nondual_app/utils/showBookLinksBottomSheet.dart';
import 'package:nondual_app/utils/showWebLinksBottomSheet.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceGrid extends StatelessWidget {
  ResourceGrid({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> openFacebook(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open Facebook');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> resources = [
      {
        'icon': Icons.local_florist_outlined,
        'label': 'Satsang - YouTube',
        'onTap': (BuildContext context) {
          showYoutubeBottomSheet(context);
        },
      },
      {
        'icon': Icons.music_note_outlined,
        'label': 'Satsang - Spotify',
        'onTap': (BuildContext context) {
          _launchUrl(
            'https://open.spotify.com/show/3diTrqSFWQfbpalggpakuO?si=b9c87030fc1d41a2',
          );
        },
      },
      {
        'icon': Icons.public,
        'label': 'Website & Q&A',
        'onTap': (BuildContext context) {
          showWebLinksBottomSheet(context);
        },
      },

      {
        'icon': Icons.groups,
        'label': 'Whatsapp',
        'onTap': (BuildContext context) {
          openWhatsAppGroup('https://chat.whatsapp.com/FRefNheLZbQAHAfaIL2SwA');
        },
      },
      {
        'icon': Icons.facebook,
        'label': 'Facebook Community',
        'onTap': (BuildContext context) {
          openFacebook(
            'https://www.facebook.com/share/g/1B73HtPCbX/?mibextid=wwXIfr',
          );
        },
      },
      {
        'icon': Icons.shopping_cart_outlined,
        'label': 'Buy Book',
        'onTap': (BuildContext context) {
          showBooksBottomSheet(context); // ✅ correct place
        },
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1B24) : Colors.white;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: resources.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final item = resources[index];
        return _AnimatedResourceCard(
          icon: item['icon'],
          label: item['label'],
          url: item['url'], // can be null
          cardColor: cardColor,
          isDark: isDark,
          onTap: () {
            final Function(BuildContext)? action = item['onTap'];
            if (action != null) {
              action(context); // run the correct tap action
            } else if (item['url'] != null) {
              _launchUrl(item['url']); // fallback if url exists
            }
          },
        );
      },
    );
  }
}

class _AnimatedResourceCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? url; // nullable
  final Color cardColor;
  final bool isDark;
  final VoidCallback onTap;

  const _AnimatedResourceCard({
    required this.icon,
    required this.label,
    required this.url,
    required this.cardColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_AnimatedResourceCard> createState() => _AnimatedResourceCardState();
}

class _AnimatedResourceCardState extends State<_AnimatedResourceCard> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : (_hover ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: widget.cardColor,
                    gradient: _hover
                        ? LinearGradient(
                            colors: widget.isDark
                                ? [
                                    const Color(0xFF2A2633),
                                    const Color(0xFF19161D),
                                  ]
                                : [
                                    const Color(0xFFF9FAFB),
                                    const Color(0xFFFFFFFF),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(
                          _hover ? 0.15 : 0.05,
                        ), // Glow when hovered
                        blurRadius: _hover ? 14 : 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: widget.isDark
                          ? Colors.white10
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      size: 34,
                      color: widget.isDark
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark ? Colors.grey.shade200 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showYoutubeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "YouTube Resources",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...youtubeLinks.map((item) {
              return ListTile(
                leading: const Icon(
                  Icons.play_circle_outline,
                  color: Colors.red,
                ),
                title: Text(item.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  final url = Uri.parse(item.url);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
              );
            }).toList(),
          ],
        ),
      );
    },
  );
}

void showBooksBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
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
            ...books.map((book) {
              return ListTile(
                leading: Image.asset(book.image, width: 40),
                title: Text(book.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  showBookLinksBottomSheet(context, book);
                },
              );
            }).toList(),
          ],
        ),
      );
    },
  );
}

Future<void> openWhatsAppGroup(String inviteLink) async {
  final uri = Uri.parse(inviteLink);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not open WhatsApp group';
  }
}
