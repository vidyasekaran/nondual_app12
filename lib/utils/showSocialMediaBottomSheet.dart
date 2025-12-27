import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/web_links.dart';

class SocialLink {
  final String title;
  final String url;
  final IconData icon;
  final Color color;

  SocialLink({
    required this.title,
    required this.url,
    required this.icon,
    required this.color,
  });
}

final List<SocialLink> socialLinks = [
  SocialLink(
    title: 'WhatsApp Community',
    url: 'https://chat.whatsapp.com/FRefNheLZbQAHAfaIL2SwA',
    icon: Icons.groups,
    color: Colors.green,
  ),
  SocialLink(
    title: 'Facebook-English',
    url: 'https://www.facebook.com/share/g/1B73HtPCbX/?mibextid=wwXIfr',
    icon: Icons.facebook,
    color: Colors.blue,
  ),
  SocialLink(
    title: 'Facebook-Tamil',
    url: 'https://www.facebook.com/share/g/17dzAKycP9/',
    icon: Icons.facebook,
    color: Colors.blue,
  ),
  SocialLink(
    title: 'Telegram Channel',
    url: 'https://web.telegram.org/k/#@ialoneprevail',
    icon: Icons.send,
    color: Colors.lightBlue,
  ),
  SocialLink(
    title: 'Instagram',
    url: 'https://www.instagram.com/gm_quotes_non_dual/',
    icon: Icons.camera_alt_outlined, // closest Material icon
    color: Colors.purple,
  ),
];

void showSocialMediaBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Social Media",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...socialLinks.map((item) {
              return ListTile(
                leading: Icon(item.icon, color: item.color),
                title: Text(item.title),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  final url = Uri.parse(item.url);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
              );
            }).toList(),
          ],
        ),
      );
    },
  );
}
