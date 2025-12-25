import 'package:flutter/material.dart';
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
      child: const Text(
        "GM's NonDual Teachings",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
