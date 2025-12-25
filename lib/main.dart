import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:http/http.dart' as http_parser;
import 'package:image_picker/image_picker.dart';
import 'package:nondual_app/screens/my_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/home_page.dart';
import 'utils/resourcegrid_nice.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
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

      /*theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ).copyWith(secondary: const Color(0xFFFF6584)),

        scaffoldBackgroundColor: const Color(0xFFF9F9F9),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontFamily: 'Times New Roman',
            fontSize: 24,
            height: 1.6,
            color: Colors.black54,
          ),
        ),
      ),*/
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9F9F9), // light background color
              Color(0xFFEFF3F6), // slightly different light tone
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const MainScaffold(),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'GM Teachings',
    debugShowCheckedModeBanner: false,
    routes: {'/admin': (context) => const AdminPage()},
    theme: ThemeData(
      primaryColor: const Color(0xFF6C63FF),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF),
      ).copyWith(secondary: const Color(0xFFFF6584)),
      scaffoldBackgroundColor:
          Colors.transparent, // transparent to show gradient
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          fontFamily: 'Times New Roman',
          fontSize: 24,
          height: 1.6,
          color: Colors.black54,
        ),
      ),
    ),
    home: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 105, 93, 238), // light background color
            Color(0xFFEFF3F6), // slightly different light tone
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const MainScaffold(),
    ),
  );
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

      // Upload the image to Supabase Storage
      await uploadImage(bytes);
    }
  }

  Future<void> uploadImage(Uint8List bytes) async {
    try {
      final today = DateTime.now();
      final date =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final path = 'quote/$date.jpg';

      // 🔥 Always delete first
      await supabase.storage.from('quote').remove([path]);

      // 🔥 Then upload
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

      final url =
          '${supabase.storage.from('quote').getPublicUrl(path)}?t=${DateTime.now().millisecondsSinceEpoch}';

      setState(() {
        uploadedUrl = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image overwritten successfully')),
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

  final List<Widget> _pages = [
    const HomePage(),
    const MyPage(),
    // const Center(child: Text("Teachings Page")),
    //const Center(child: Text("Resources Page")),
    ResourceGrid(),
    const Center(child: Text("About Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Teachings',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Resources',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}

class AdminLongPressTitle extends StatefulWidget {
  const AdminLongPressTitle({super.key});

  @override
  State<AdminLongPressTitle> createState() => AdminLongPressTitleState();
}

class AdminLongPressTitleState extends State<AdminLongPressTitle> {
  Timer? _adminTimer;
  bool _adminPressing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressStart: (_) {
        print("Long press started");
        _adminPressing = true;

        _adminTimer = Timer(const Duration(seconds: 1), () {
          if (_adminPressing) {
            print("Admin unlocked");
            Navigator.of(context).pushNamed('/admin');
          }
        });
      },
      onLongPressEnd: (_) {
        print("Long press ended");
        _adminPressing = false;
        _adminTimer?.cancel();
      },
      child: const Text(
        "GM's NonDual Teachings",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
