import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceItem {
  final IconData icon;
  final String label;
  final String url;

  ResourceItem(this.icon, this.label, this.url);
}

List<ResourceItem> getResourcesForLanguage(String lang) {
  return [
    ResourceItem(Icons.book, "Teachings", "https://example.com"),
    ResourceItem(Icons.video_library, "Videos", "https://example.com"),
    ResourceItem(Icons.audiotrack, "Audio", "https://example.com"),
  ];
}

void launchResource(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
