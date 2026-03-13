import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:nondual_app/screens/about_gm.dart';
import 'package:nondual_app/screens/question_answer.dart';

import 'package:nondual_app/screens/todaysquote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/adminlongpresstitle.dart';
import '../utils/resourcegrid_nice.dart';
import 'my_page.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  final String? aboutHeaderUrl;
  const HomePage({super.key, this.aboutHeaderUrl});

  @override
  State<HomePage> createState() => _HomePageState();
}

String _formatDuration(Duration d) {
  final mins = d.inMinutes;
  final secs = d.inSeconds.remainder(60);
  return '${mins}:${secs.toString().padLeft(2, '0')}';
}

class _MeditationPlayerProgress extends StatefulWidget {
  final AudioPlayer player;

  const _MeditationPlayerProgress({required this.player});

  @override
  State<_MeditationPlayerProgress> createState() =>
      _MeditationPlayerProgressState();
}

class _MeditationPlayerProgressState extends State<_MeditationPlayerProgress> {
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;

  @override
  void initState() {
    super.initState();
    _positionSub = widget.player.positionStream.listen((_) {
      if (mounted) setState(() {});
    });
    _durationSub = widget.player.durationStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final position = widget.player.position;
    final duration = widget.player.duration ?? Duration.zero;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.4),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
            ),
            child: Slider(
              value: duration.inMilliseconds > 0
                  ? position.inMilliseconds
                        .clamp(0, duration.inMilliseconds)
                        .toDouble()
                  : 0,
              min: 0,
              max: duration.inMilliseconds > 0
                  ? duration.inMilliseconds.toDouble()
                  : 1,
              onChanged: (value) {
                widget.player.seek(Duration(milliseconds: value.round()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlayingPath;

  // ignore: unused_element
  Future<void> _toggleAudio(String path) async {
    if (_currentlyPlayingPath != path) {
      await _player.setAsset(path);
      await _player.play();
      setState(() {
        _currentlyPlayingPath = path;
      });
    } else {
      if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Light green background
      appBar: AppBar(
        title: AdminLongPressTitle(),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 55, 131, 60), // Much darker green
                const Color.fromARGB(255, 42, 126, 46), // Darker green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        scrolledUnderElevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
            onSelected: (value) {
              if (value == 'Downloads') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(" GM's Calendar"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.picture_as_pdf),
                          title: const Text("GM's Calendar"),
                          onTap: () async {
                            const url =
                                'https://rvevlngiswoduyxwetsb.supabase.co/storage/v1/object/public/quote/calander/cover.pdf';
                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Could not launch URL'),
                                  ),
                                );
                              }
                            }
                            if (context.mounted) Navigator.pop(ctx);
                          },
                        ),
                      ],
                    ),
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
                if (widget.aboutHeaderUrl != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.aboutHeaderUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                AboutGMPage(),

                // QuotePage(),
                TodaysQuote(),
                MyPage(),
                QAPage(),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        112,
                        202,
                        115,
                      ), // lighter green, similar to Teachings
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor:
                            Colors.transparent, // 👈 removes top & bottom lines
                      ),
                      child: ExpansionTile(
                        trailing: Image.asset(
                          "assets/images/down.png",
                          width: 28,
                          height: 28,
                        ),
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "🌼 GM's Eternal Guided Meditation",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: const Color(
                                0xFFE8F5E9,
                              ), // light green for dark background
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        children: [
                          ListTile(
                            title: const Text(
                              'Know the infinity of the Non Dual Reality.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/0oqE8lGPAHVw5sJRR4gDLo",
                              );
                            },
                          ),

                          ListTile(
                            title: const Text(
                              'Settle Inwardly Where You are Already.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/53TA6W7PxRZW22tFO4Aj4A",
                              );
                            },
                          ),

                          ListTile(
                            title: const Text(
                              'I am Revealing the Highest Truth about Your Completeness, Wholeness Beyond space.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/0gcxnKK1ncpw9pA62a1aGb",
                              );
                            },
                          ),

                          ListTile(
                            title: const Text(
                              'Know the Unending Love beyond words.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/4WOUCWZxz3FwUViAKClX4J",
                              );
                            },
                          ),

                          ListTile(
                            title: const Text(
                              'Inwardly You are Already That and Always That.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/1RhI9ulmhRW4tlc6OcNBGB",
                              );
                            },
                          ),

                          ListTile(
                            title: const Text(
                              'Stay beyond words and Observe Silently.!',
                            ),
                            trailing: const Icon(Icons.play_arrow),
                            onTap: () {
                              openPodcast(
                                "https://open.spotify.com/episode/5zIkKQJg4sPCXWRoWD3ePU",
                              );
                            },
                          ),

                          /*   ListTile(
                            title: const Text('About Thoughts'),
                            trailing: StreamBuilder<PlayerState>(
                              stream: _player.playerStateStream,
                              builder: (context, snapshot) {
                                final playing = snapshot.data?.playing ?? false;

                                final isThisPlaying =
                                    _currentlyPlayingPath ==
                                    'assets/audio/ilnoor-thoughts-v3.mp3';

                                return Icon(
                                  isThisPlaying && playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                );
                              },
                            ),
                            onTap: () {
                              _toggleAudio(
                                'assets/audio/ilnoor-thoughts-v3.mp3',
                              );
                            },
                          ),

                          ListTile(
                            title: const Text('Highest State'),
                            trailing: StreamBuilder<PlayerState>(
                              stream: _player.playerStateStream,
                              builder: (context, snapshot) {
                                final playing = snapshot.data?.playing ?? false;

                                final isThisPlaying =
                                    _currentlyPlayingPath ==
                                    'assets/audio/2025_04_10_11_55_31-v2.mp3';

                                return Icon(
                                  isThisPlaying && playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                );
                              },
                            ),
                            onTap: () {
                              _toggleAudio(
                                'assets/audio/2025_04_10_11_55_31-v2.mp3',
                              );
                            },
                          ),
                          if (_currentlyPlayingPath != null)
                            _MeditationPlayerProgress(player: _player),*/
                        ],
                      ),
                    ),
                  ),
                ),

                const AllQuotesGallery(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(
                                  0xFFC8E6C9,
                                ), // Slightly darker green
                                const Color(
                                  0xFFB8D9BA,
                                ), // Even slightly darker for depth
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 6),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(-3, -3),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "🌻 Resource Library",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  height: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(
                                    0xFF0D4F1C,
                                  ), // Dark green for better readability
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              ResourceGrid(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<String>> fetchAllQuoteImages() async {
  try {
    final supabase = Supabase.instance.client;
    final files = await supabase.storage.from('quote').list(path: 'allquotes');

    final imageUrls = files
        .where(
          (f) =>
              f.name.endsWith('.jpeg') ||
              f.name.endsWith('.jpg') ||
              f.name.endsWith('.png'),
        )
        .map(
          (f) =>
              '${supabase.storage.from('quote').getPublicUrl('allquotes/${f.name}')}?v=${f.name}',
        )
        .toSet()
        .toList();

    imageUrls.shuffle();
    if (imageUrls.isNotEmpty) return imageUrls;
  } catch (_) {
    // fall through to offline assets
  }

  final local = await fetchLocalQuoteAssets();
  local.shuffle();
  return local;
}

Future<List<String>> fetchLocalQuoteAssets() async {
  final manifestJson = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestJson);
  final assets = manifestMap.keys
      .where((key) => key.startsWith('assets/images/quotes/'))
      .where(
        (key) =>
            key.endsWith('.jpeg') ||
            key.endsWith('.jpg') ||
            key.endsWith('.png'),
      )
      .toList();
  assets.sort();
  return assets;
}

bool _isNetworkImagePath(String path) =>
    path.startsWith('http://') || path.startsWith('https://');

Future<List<String>>? _localQuoteAssetsCache;
Future<List<String>> _getLocalQuoteAssetsCached() =>
    _localQuoteAssetsCache ??= fetchLocalQuoteAssets();

String? _mapNetworkUrlToLocalAsset(String url, List<String> localAssets) {
  final uri = Uri.tryParse(url);
  final last = uri?.pathSegments.isNotEmpty == true
      ? uri!.pathSegments.last
      : '';
  if (last.isEmpty) return null;

  // If Supabase file is `.../allquotes/1.jpeg`, try to match `assets/images/quotes/1.jpeg`
  for (final a in localAssets) {
    if (a.endsWith('/$last')) return a;
  }
  return null;
}

Widget _quoteImageWidget(String path, {BoxFit fit = BoxFit.cover}) {
  if (!_isNetworkImagePath(path)) {
    return Image.asset(
      path,
      key: ValueKey(path),
      fit: fit,
      gaplessPlayback: false,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
    );
  }

  return Image.network(
    path,
    key: ValueKey(path),
    fit: fit,
    gaplessPlayback: false,
    errorBuilder: (context, error, stackTrace) {
      return FutureBuilder<List<String>>(
        future: _getLocalQuoteAssetsCached(),
        builder: (context, snapshot) {
          final localAssets = snapshot.data ?? const <String>[];
          final mapped = _mapNetworkUrlToLocalAsset(path, localAssets);
          if (mapped != null) {
            return Image.asset(
              mapped,
              key: ValueKey(mapped),
              fit: fit,
              gaplessPlayback: false,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            );
          }
          return const Icon(Icons.broken_image);
        },
      );
    },
  );
}

class AllQuotesGallery extends StatelessWidget {
  const AllQuotesGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFC8E6C9), // lighter green, like other cards
                    const Color(0xFFB8D9BA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(-3, -3),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "🌸 GM's Eternal Quotes",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      color: const Color(
                        0xFF0D4F1C,
                      ), // Dark green for good contrast on light background
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  FutureBuilder<List<String>>(
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
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _showImageViewer(context, images, index);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _quoteImageWidget(images[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                  child: _quoteImageWidget(images[index], fit: BoxFit.contain),
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
          return Image.network(
            images[index],
            key: ValueKey(images[index]),
            fit: BoxFit.contain,
            gaplessPlayback: false,
          );
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

Future<void> openPodcast(String podcastUrl) async {
  final Uri url = Uri.parse(podcastUrl);

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $podcastUrl';
  }
}
