// data/youtube_links.dart
class Link {
  final String title;
  final String url;

  Link({required this.title, required this.url});
}

final List<Link> youtubeLinks = [
  Link(
    title: 'GM Teachings – English',
    url: 'https://youtube.com/@teachingsofgm',
  ),
  Link(
    title: 'GM Teachings – Tamil',
    url: 'https://www.youtube.com/@tamilteachingsofgm',
  ),
  Link(title: 'NonDual Songs', url: 'https://www.youtube.com/@GMNonDualSongs'),
  Link(
    title: 'Short Teachings',
    url: 'https://www.youtube.com/@teachingsofgm/shorts',
  ),
];

final List<Link> spotifyLinks = [
  Link(
    title: 'GM Teachings – English',
    url:
        'https://open.spotify.com/show/3diTrqSFWQfbpalggpakuO?si=b9c87030fc1d41a2',
  ),
  Link(
    title: 'GM Teachings – Tamil',
    url:
        'https://open.spotify.com/show/5xvZEyMXunQrcp99ELS65z?si=KEyNqlGxS6y-vDhXP9o5cw',
  ),
];
