import 'package:flutter_test/flutter_test.dart';
import 'package:lingua/data/vocabulary_data.dart';

void main() {
  test('All categories have words', () {
    for (final category in VocabularyData.categories) {
      final words = VocabularyData.getWordsForCategory(category.id);
      expect(words.isNotEmpty, true,
          reason: '${category.name} should have words');
    }
  });

  test('Each category has 10 words', () {
    for (final category in VocabularyData.categories) {
      final words = VocabularyData.getWordsForCategory(category.id);
      expect(words.length, 10,
          reason: '${category.name} should have 10 words');
    }
  });

  test('All words have required fields', () {
    for (final word in VocabularyData.allWords) {
      expect(word.english.isNotEmpty, true);
      expect(word.italian.isNotEmpty, true);
      expect(word.emoji.isNotEmpty, true);
      expect(word.category.isNotEmpty, true);
    }
  });
}
