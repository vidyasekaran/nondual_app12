import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nondual_app/data/books_data.dart';
import 'package:nondual_app/data/youtube_links.dart';
import 'package:nondual_app/model/gm_gpt_model.dart';
import 'package:nondual_app/utils/showBookLinksBottomSheet.dart';
import 'package:nondual_app/utils/showSocialMediaBottomSheet.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/web_links.dart';

class ResourceGrid extends StatelessWidget {
  const ResourceGrid({super.key});

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
        'icon': FontAwesomeIcons.youtube,
        'iconColor': const Color(0xFFFF0000), // YouTube red
        'label': 'GM Teachings',
        'onTap': (BuildContext context) {
          showYoutubeBottomSheet(context);
        },
      },
      {
        'icon': FontAwesomeIcons.spotify,
        'iconColor': const Color(0xFF1DB954), // Spotify green
        'label': 'GM Teachings',
        'onTap': (BuildContext context) {
          showSpotifyBottomSheet(context);
        },
      },
      {
        'icon': FontAwesomeIcons.globe,
        'iconColor': const Color(0xFF4285F4), // Web blue
        'label': 'Website',
        'onTap': (BuildContext context) {
          showWebLinksBottomSheet(context);
        },
      },
      {
        'icon': FontAwesomeIcons.shareNodes,
        'iconColor': const Color(0xFFE1306C), // Social/Instagram pink
        'label': 'Social Media',
        'onTap': (BuildContext context) {
          showSocialMediaBottomSheet(context);
        },
      },
      {
        'icon': FontAwesomeIcons.amazon,
        'iconColor': const Color(0xFFFF9900), // Amazon orange
        'label': 'Books By GM',
        'onTap': (BuildContext context) {
          showBooksBottomSheet(context);
        },
      },
      {
        'icon': FontAwesomeIcons.robot,
        'iconColor': const Color(0xFF10A37F), // AI/ChatGPT green
        'label': 'GM GPT',
        'onTap': (BuildContext context) {
          showGmGptBottomSheet(context);
        },
      },
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1B24) : Colors.white;

    final isNarrow = MediaQuery.of(context).size.width < 400;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: resources.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: isNarrow ? 0.75 : 0.85,
      ),
      itemBuilder: (context, index) {
        final item = resources[index];
        return _AnimatedResourceCard(
          icon: item['icon'],
          iconColor: item['iconColor'] as Color?,
          label: item['label'],
          isNarrow: isNarrow,
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
          onLongPress: item['onLongPress'] as VoidCallback?,
        );
      },
    );
  }
}

class _AnimatedResourceCard extends StatefulWidget {
  final IconData icon;
  final Color? iconColor;
  final String label;
  final String? url; // nullable
  final Color cardColor;
  final bool isDark;
  final bool isNarrow;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _AnimatedResourceCard({
    required this.icon,
    this.iconColor,
    required this.label,
    required this.url,
    required this.cardColor,
    required this.isDark,
    this.isNarrow = false,
    required this.onTap,
    this.onLongPress,
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
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _pressed ? 0.95 : (_hover ? 1.05 : 1.0),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
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
                    child: Padding(
                      padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width < 400 ? 8 : 12,
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: FaIcon(
                            widget.icon,
                            size: 34,
                            color:
                                widget.iconColor ??
                                (widget.isDark
                                    ? Colors.grey.shade300
                                    : Colors.grey.shade700),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: widget.isNarrow ? 10.5 : 12,
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

void showSpotifyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Spotify Resources",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ...spotifyLinks.map((item) {
                return ListTile(
                  leading: const Icon(
                    Icons.music_note_outlined,
                    color: Colors.green,
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
        ),
      );
    },
  );
}

void showYoutubeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
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
      return SafeArea(
        child: Padding(
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
        ),
      );
    },
  );
}

void showWebLinksBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Website & Q&A",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ...webLinks.map((item) {
                return ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    Navigator.pop(context);
                    final uri = Uri.parse(item.url);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}

void showGmGptBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "GM GPT – AI Guidance",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                "This opens a personal AI conversation (not a group chat).",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 16),

              ...gmGptLinks.map((item) {
                return ListTile(
                  leading: Icon(item.icon, color: item.color),
                  title: Text(item.title),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    Navigator.pop(context);
                    final uri = Uri.parse(item.url);
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                );
              }).toList(),
            ],
          ),
        ),
      );
    },
  );
}
