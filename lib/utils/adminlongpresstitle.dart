import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

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
        _adminPressing = true;

        _adminTimer = Timer(const Duration(seconds: 1), () {
          if (_adminPressing) {
            Navigator.of(context).pushNamed('/admin');
          }
        });
      },
      onLongPressEnd: (_) {
        _adminPressing = false;
        _adminTimer?.cancel();
      },

      child: Row(
        mainAxisSize: MainAxisSize.min, // important for AppBar
        children: [
          const SizedBox(width: 10),
          Text(
            "GM's NonDual Teachings",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 239, 241, 237),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
