import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:http/http.dart' as http_parser;
import 'package:image_picker/image_picker.dart';
import 'package:nondual_app/screens/my_page.dart';
import 'package:nondual_app/screens/question_answer.dart';
import 'package:nondual_app/screens/splashpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_page.dart';
import 'utils/resourcegrid_nice.dart';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = 'https://rvevlngiswoduyxwetsb.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ2ZXZsbmdpc3dvZHV5eHdldHNiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYwODg3NzUsImV4cCI6MjA4MTY2NDc3NX0.GZIx0yYfLIMohNMjFY25vmitKihK5bNalHPclrQI3Gc';

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  runApp(const GMTApp());
}

class GMTApp extends StatelessWidget {
  const GMTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GM Teachings',
      debugShowCheckedModeBanner: false,

      routes: {'/admin': (context) => const AdminPage()},

      /*home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9), // light green background color
              Color(0xFFE1F5E3), // slightly different light green tone
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const MainScaffold(),
      ),*/
      home: const SplashPage(),
    );
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  Uint8List? imageBytes;
  String? uploadedUrl;
  final SupabaseClient supabase = Supabase.instance.client;

  // Pick image from gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });

      // Extract file extension from the picked file
      final fileName = pickedFile.name;
      final extension = fileName.contains('.')
          ? fileName.substring(fileName.lastIndexOf('.'))
          : '.jpg'; // Default to .jpg if no extension found

      // Upload the image to Supabase Storage
      await uploadImage(bytes, extension);
    }
  }

  Future<void> uploadImage(Uint8List bytes, String extension) async {
    try {
      // Use 'todayquote' as filename with the original extension
      final path = 'quote/todayquote$extension';

      // Delete any existing todayquote files (with any extension)
      try {
        final files = await supabase.storage.from('quote').list(path: 'quote');
        final todayquoteFiles = files
            .where((f) => f.name.startsWith('todayquote'))
            .map((f) => 'quote/${f.name}')
            .toList();

        if (todayquoteFiles.isNotEmpty) {
          await supabase.storage.from('quote').remove(todayquoteFiles);
        }
      } catch (e) {
        // Ignore errors when deleting (file might not exist)
      }

      // Determine content type based on extension
      String contentType;
      switch (extension.toLowerCase()) {
        case '.jpg':
        case '.jpeg':
          contentType = 'image/jpeg';
          break;
        case '.png':
          contentType = 'image/png';
          break;
        case '.gif':
          contentType = 'image/gif';
          break;
        case '.webp':
          contentType = 'image/webp';
          break;
        default:
          contentType = 'image/jpeg'; // Default fallback
      }

      // Upload with the new filename
      await supabase.storage
          .from('quote')
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              cacheControl: 'no-cache',
            ),
          );

      final url =
          '${supabase.storage.from('quote').getPublicUrl(path)}?t=${DateTime.now().millisecondsSinceEpoch}';

      setState(() {
        uploadedUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image uploaded as todayquote successfully'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (imageBytes != null)
              Image.memory(
                imageBytes!,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              )
            else
              const SizedBox(
                width: double.infinity,
                height: 250,
                child: Center(child: Text('No image selected')),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick and Upload Image'),
            ),
            if (uploadedUrl != null) ...[
              const SizedBox(height: 16),
              SelectableText('Uploaded URL:\n$uploadedUrl'),
            ],
          ],
        ),
      ),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  String? _aboutHeaderUrl;

  @override
  void initState() {
    super.initState();
    _loadTodaysAboutHeader();
  }

  Future<void> _loadTodaysAboutHeader() async {
    try {
      final supabase = Supabase.instance.client;
      final today = DateTime.now();
      final date =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final path = 'aboutheader/$date.jpg';

      final publicUrl =
          '${supabase.storage.from('quote').getPublicUrl(path)}?t=${DateTime.now().millisecondsSinceEpoch}';

      final resp = await http_parser.head(Uri.parse(publicUrl));
      if (resp.statusCode == 200) {
        setState(() {
          _aboutHeaderUrl = publicUrl;
        });
      }
    } catch (_) {
      // silently ignore if not present
    }
  }

  /*Holiday upload logic commented..
  It shows image picker and then uploads image to supabase...
  Future<void> _pickAboutImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _aboutImageBytes = bytes;
      });

      // Upload to Supabase so it persists for the day
      try {
        final supabase = Supabase.instance.client;
        final today = DateTime.now();
        final date =
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
        final path = 'aboutheader/$date.jpg';

        await supabase.storage.from('quote').remove([path]);
        await supabase.storage
            .from('quote')
            .uploadBinary(
              path,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                cacheControl: 'no-cache',
              ),
            );

        final publicUrl =
            '${supabase.storage.from('quote').getPublicUrl(path)}?t=${DateTime.now().millisecondsSinceEpoch}';

        setState(() {
          _aboutHeaderUrl = publicUrl;
        });
      } catch (e) {
        // ignore upload errors for now, local bytes still shown
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image selected for About GM')),
        );
      }
    }
  }*/

  List<Widget> get _pages => [
    HomePage(aboutHeaderUrl: _aboutHeaderUrl),
    const MyPage(),
    const ResourceGrid(),
    const QAPage(),
    const Center(child: Text("About Page - Version 2.1")),
  ];

  Widget _buildNavIcon(
    IconData icon,
    List<Color> gradientColors, {
    bool selected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: gradientColors.last.withOpacity(0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
        border: Border.all(
          color: selected
              ? Colors.white.withOpacity(0.75)
              : Colors.white.withOpacity(0.25),
          width: selected ? 1.2 : 0.8,
        ),
      ),
      child: Icon(
        icon,
        size: 22,
        color: selected ? Colors.white : Colors.white.withOpacity(0.92),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1B5E20), // Much darker green
              const Color(0xFF2E7D32), // Darker green
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.3,
                  );
                }
                return GoogleFonts.inter(
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  letterSpacing: 0.3,
                );
              }),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            indicatorColor: Colors.white.withOpacity(
              0.3,
            ), // Light indicator for dark green footer
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: _buildNavIcon(
                  LucideIcons.home,
                  const [Color(0xFF2BD9A7), Color(0xFF14B8A6)],
                ),
                selectedIcon: _buildNavIcon(
                  LucideIcons.home,
                  const [Color(0xFF2BD9A7), Color(0xFF14B8A6)],
                  selected: true,
                ),
                label: 'Home',
              ),
              NavigationDestination(
                icon: _buildNavIcon(
                  LucideIcons.flower2,
                  const [Color(0xFFB97AFF), Color(0xFF7C3AED)],
                ),
                selectedIcon: _buildNavIcon(
                  LucideIcons.flower2,
                  const [Color(0xFFB97AFF), Color(0xFF7C3AED)],
                  selected: true,
                ),
                label: 'Teachings',
              ),
              
              NavigationDestination(
                icon: _buildNavIcon(
                  LucideIcons.bookOpen,
                  const [Color(0xFF60A5FA), Color(0xFF2563EB)],
                ),
                selectedIcon: _buildNavIcon(
                  LucideIcons.bookOpen,
                  const [Color(0xFF60A5FA), Color(0xFF2563EB)],
                  selected: true,
                ),
                label: 'Resources',
              ),
              NavigationDestination(
                icon: _buildNavIcon(
                  LucideIcons.messagesSquare,
                  const [Color(0xFFFFC857), Color(0xFFF97316)],
                ),
                selectedIcon: _buildNavIcon(
                  LucideIcons.messagesSquare,
                  const [Color(0xFFFFC857), Color(0xFFF97316)],
                  selected: true,
                ),
                label: 'Q & A',
              ),
              /*              Holiday upload logic commented..*/
              NavigationDestination(
                icon: GestureDetector(
                  //onDoubleTap: _pickAboutImage,
                  child: _buildNavIcon(
                    LucideIcons.info,
                    const [Color(0xFFFF7A8A), Color(0xFFEF4444)],
                  ),
                ),
                selectedIcon: GestureDetector(
                  //onDoubleTap: _pickAboutImage,
                  child: _buildNavIcon(
                    LucideIcons.info,
                    const [Color(0xFFFF7A8A), Color(0xFFEF4444)],
                    selected: true,
                  ),
                ),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
