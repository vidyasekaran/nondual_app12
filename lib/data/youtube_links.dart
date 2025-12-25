// data/youtube_links.dart
class YoutubeLink {
  final String title;
  final String url;

  YoutubeLink({required this.title, required this.url});
}

final List<YoutubeLink> youtubeLinks = [
  YoutubeLink(
    title: 'Satsang – Main Channel',
    url: 'https://youtube.com/@teachingsofgm',
  ),
  YoutubeLink(
    title: 'NonDual Songs',
    url: 'https://www.youtube.com/@GMNonDualSongs',
  ),
  YoutubeLink(
    title: 'Short Teachings',
    url: 'https://www.youtube.com/@teachingsofgm/shorts',
  ),
];
