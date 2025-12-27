import 'dart:math';

final List<String> gmInsights = [
  "Stillness is not something to be achieved; it is what you already are.",
  "The seeker disappears when truth is seen.",
  "Freedom is not in experience but prior to experience.",
  "Suffering belongs to identification, not to awareness.",
  "Silence is the teaching; words only point.",
  "Nothing needs to be added for wholeness to be recognized.",
];

String getRandomGMInsight() {
  final random = Random();
  return gmInsights[random.nextInt(gmInsights.length)];
}
