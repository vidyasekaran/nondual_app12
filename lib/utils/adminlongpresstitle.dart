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
      child: Text(
        "GM's NonDual Teachings",
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white, // White text for readability on dark header
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
