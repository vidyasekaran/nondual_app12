import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'adminlongpresstitle.dart';
import 'package:flutter/services.dart' show rootBundle;

class CoreTeachings extends StatelessWidget {
  const CoreTeachings({super.key});

  Future<String> loadText() async {
    return await rootBundle.loadString('assets/text/coreteaching.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AdminLongPressTitle(),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder(
        future: loadText(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          const imgUrl =
              'https://rvevlngiswoduyxwetsb.supabase.co/storage/v1/object/public/quote/quote/GM_Photo.jpeg';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imgUrl),
                ),
                const SizedBox(height: 24),

                Text(
                  snapshot.data!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 4, 17, 129),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
