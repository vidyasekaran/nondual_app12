import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  Future<String> loadTeaching1() async {
    return await rootBundle.loadString('assets/text/teaching1.txt');
  }

  Future<String> loadTeaching2() async {
    return await rootBundle.loadString('assets/text/teaching2.txt');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([loadTeaching1(), loadTeaching2()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final teaching1 = snapshot.data![0];
        final teaching2 = snapshot.data![1];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Core Teachings of GM",
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 12),

              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  "1. IAM THE SOURCE OF ALL.!",
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      teaching1,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),

              // Teaching 2 (Expandable Tile)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text(
                  "2. STILLNESS IS THE WAY TO THE SUPREME.!",
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'PlayfairDisplay',
                    fontWeight: FontWeight.bold,
                  ),
                ),

                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      teaching2,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontFamily: 'PlayfairDisplay',
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
