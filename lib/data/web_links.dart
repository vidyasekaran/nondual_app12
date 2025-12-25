class WebLink {
  final String title;
  final String url;

  WebLink({required this.title, required this.url});
}

final List<WebLink> webLinks = [
  WebLink(title: 'Official Website', url: 'https://youarealreadythat.com/'),
  WebLink(
    title: 'Q & A',
    url: 'https://youarealreadythat.com/category/question-answers/',
  ),
];
