import 'package:flutter/material.dart';

class GmGptLink {
  final String title;
  final String url;
  final IconData icon;
  final Color color;

  GmGptLink({
    required this.title,
    required this.url,
    required this.icon,
    required this.color,
  });
}

final List<GmGptLink> gmGptLinks = [
  GmGptLink(
    title: "Chat with GM GPT",
    url:
        "https://chatgpt.com/g/g-6946b05e83408191bbedae402e805abd-gm-gpt-the-voice-of-the-absolute",
    icon: Icons.smart_toy_outlined,
    color: Colors.black,
  ),
];
