import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adminlongpresstitle.dart';

class CoreTeachings extends StatelessWidget {
  const CoreTeachings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdminLongPressTitle(),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://picsum.photos/800/600'),
            ),
            const SizedBox(height: 24),

            // TEMPORARY text — replace with FutureBuilder later
            Text(
              "First, know that you are Conscious of yourself! In your ‘I am ness’ Consciousness only everything appears…happens and disappears too… Where does all form exist? Can any form exist when you are not Conscious of yourself? You come to know your existence as ‘I am ness’ only due to Consciousness within just now.!",
              style: GoogleFonts.newsreader(fontSize: 18, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
