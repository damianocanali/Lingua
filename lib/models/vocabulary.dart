class VocabularyWord {
  final String id;
  final String english;
  final String italian;
  final String emoji;
  final String category;

  const VocabularyWord({
    required this.id,
    required this.english,
    required this.italian,
    required this.emoji,
    required this.category,
  });
}

class Category {
  final String id;
  final String name;
  final String emoji;
  final int colorValue;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorValue,
  });
}
