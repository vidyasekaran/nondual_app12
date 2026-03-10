import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';

class QAPage extends StatelessWidget {
  const QAPage({super.key});

  Future<String> loadQA1() async {
    return await rootBundle.loadString('assets/text/qa1.txt');
  }

  Future<String> loadQA2() async {
    return await rootBundle.loadString('assets/text/qa2.txt');
  }

  Future<String> loadQA3() async {
    return await rootBundle.loadString('assets/text/qa3.txt');
  }

    Future<String> loadQA4() async {
    return await rootBundle.loadString('assets/text/qa4.txt');
  }


    Future<String> loadQA5() async {
    return await rootBundle.loadString('assets/text/qa5.txt');
  }

    Future<String> loadQA6() async {
    return await rootBundle.loadString('assets/text/qa6.txt');
  }
    Future<String> loadQA7() async {
    return await rootBundle.loadString('assets/text/qa7.txt');
  }

    Future<String> loadQA8() async {
    return await rootBundle.loadString('assets/text/qa8.txt');
  }

    Future<String> loadQA9() async {
    return await rootBundle.loadString('assets/text/qa9.txt');
  }

    Future<String> loadQA10() async {
    return await rootBundle.loadString('assets/text/qa10.txt');
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([loadQA1(), loadQA2(), loadQA3(), loadQA4(), loadQA5(), loadQA6(), loadQA7(), loadQA8(), loadQA9(), loadQA10()]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final teaching1 = snapshot.data![0];
        final teaching2 = snapshot.data![1];
        final teaching3 = snapshot.data![2];
        final teaching4 = snapshot.data![3];
        final teaching5 = snapshot.data![4];
        final teaching6 = snapshot.data![5];
        final teaching7 = snapshot.data![6];
        final teaching8 = snapshot.data![7];
        final teaching9 = snapshot.data![8];
        final teaching10 = snapshot.data![9];

        return SingleChildScrollView(
          child: Padding(
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
                          const Color.fromARGB(
                            255,
                            112,
                            202,
                            115,
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
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors
                            .transparent, // removes ExpansionTile divider lines
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
                            "🌺  GM's Eternal Teachings",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 6, 80, 23),
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        children: [
                          buildTile("Witnessing and Observing", teaching1),
                          buildTile("Nature of Consciousness", teaching2),
                          buildTile("What is freedom?", teaching3),
                          buildTile("What is Self Realization?", teaching4),
                          buildTile("Is the Observer the observed?", teaching5),
                          buildTile("What is Just be mean?", teaching6),
                          buildTile(
                            "What is the purpose of Human Birth?",
                            teaching7,
                          ),
                          buildTile(
                            "Difference between Consciousness, Awareness, and Observer",
                            teaching8,
                          ),
                          buildTile(
                            "Are all my Life Events Pre-ordained?",
                            teaching9,
                          ),
                          buildTile(
                            "Eating non-vegetarian food a barrier to spiritual progress?",
                            teaching10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                         
              ],
            ),
          ),
        );
      },
    );
  }
}



Widget buildTile(String title, String content) {
                      return ExpansionTile(
                          trailing: Image.asset(
                            "assets/images/down.png",
                            width: 28,
                            height: 28,
                          ),

                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          textColor: const Color(
                            0xFF0D4F1C,
                          ), // Dark green for better readability
                          iconColor: const Color(0xFF0D4F1C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          collapsedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(
                                0xFF0D4F1C,
                              ), // Dark green for better readability
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.left,
                          ),

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                content,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(
                                    0xFF0D4F1C,
                                  ), // Dark green for better readability
                                  letterSpacing: 0.2,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        );
}
