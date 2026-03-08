import '../models/vocabulary.dart';

class VocabularyData {
  static const List<Category> categories = [
    Category(id: 'animals', name: 'Animali', emoji: '🐾', colorValue: 0xFF55E6C1),
    Category(id: 'food', name: 'Cibo', emoji: '🍕', colorValue: 0xFFFF9FF3),
    Category(id: 'family', name: 'Famiglia', emoji: '👨‍👩‍👦', colorValue: 0xFFFF6B6B),
    Category(id: 'colors', name: 'Colori', emoji: '🎨', colorValue: 0xFFFECA57),
    Category(id: 'numbers', name: 'Numeri', emoji: '🔢', colorValue: 0xFF48DBFB),
    Category(id: 'body', name: 'Corpo', emoji: '🦶', colorValue: 0xFFFF9F43),
    Category(id: 'greetings', name: 'Saluti', emoji: '👋', colorValue: 0xFFA29BFE),
    Category(id: 'nature', name: 'Natura', emoji: '🌿', colorValue: 0xFF2ECC71),
  ];

  static const List<VocabularyWord> allWords = [
    // Animals
    VocabularyWord(id: 'a1', english: 'Dog', italian: 'Cane', emoji: '🐕', category: 'animals'),
    VocabularyWord(id: 'a2', english: 'Cat', italian: 'Gatto', emoji: '🐈', category: 'animals'),
    VocabularyWord(id: 'a3', english: 'Bird', italian: 'Uccello', emoji: '🐦', category: 'animals'),
    VocabularyWord(id: 'a4', english: 'Fish', italian: 'Pesce', emoji: '🐟', category: 'animals'),
    VocabularyWord(id: 'a5', english: 'Horse', italian: 'Cavallo', emoji: '🐴', category: 'animals'),
    VocabularyWord(id: 'a6', english: 'Rabbit', italian: 'Coniglio', emoji: '🐰', category: 'animals'),
    VocabularyWord(id: 'a7', english: 'Bear', italian: 'Orso', emoji: '🐻', category: 'animals'),
    VocabularyWord(id: 'a8', english: 'Lion', italian: 'Leone', emoji: '🦁', category: 'animals'),
    VocabularyWord(id: 'a9', english: 'Elephant', italian: 'Elefante', emoji: '🐘', category: 'animals'),
    VocabularyWord(id: 'a10', english: 'Butterfly', italian: 'Farfalla', emoji: '🦋', category: 'animals'),

    // Food
    VocabularyWord(id: 'f1', english: 'Pizza', italian: 'Pizza', emoji: '🍕', category: 'food'),
    VocabularyWord(id: 'f2', english: 'Bread', italian: 'Pane', emoji: '🍞', category: 'food'),
    VocabularyWord(id: 'f3', english: 'Water', italian: 'Acqua', emoji: '💧', category: 'food'),
    VocabularyWord(id: 'f4', english: 'Milk', italian: 'Latte', emoji: '🥛', category: 'food'),
    VocabularyWord(id: 'f5', english: 'Apple', italian: 'Mela', emoji: '🍎', category: 'food'),
    VocabularyWord(id: 'f6', english: 'Ice cream', italian: 'Gelato', emoji: '🍦', category: 'food'),
    VocabularyWord(id: 'f7', english: 'Cheese', italian: 'Formaggio', emoji: '🧀', category: 'food'),
    VocabularyWord(id: 'f8', english: 'Pasta', italian: 'Pasta', emoji: '🍝', category: 'food'),
    VocabularyWord(id: 'f9', english: 'Cake', italian: 'Torta', emoji: '🎂', category: 'food'),
    VocabularyWord(id: 'f10', english: 'Banana', italian: 'Banana', emoji: '🍌', category: 'food'),

    // Family
    VocabularyWord(id: 'fm1', english: 'Mom', italian: 'Mamma', emoji: '👩', category: 'family'),
    VocabularyWord(id: 'fm2', english: 'Dad', italian: 'Papà', emoji: '👨', category: 'family'),
    VocabularyWord(id: 'fm3', english: 'Brother', italian: 'Fratello', emoji: '👦', category: 'family'),
    VocabularyWord(id: 'fm4', english: 'Sister', italian: 'Sorella', emoji: '👧', category: 'family'),
    VocabularyWord(id: 'fm5', english: 'Grandma', italian: 'Nonna', emoji: '👵', category: 'family'),
    VocabularyWord(id: 'fm6', english: 'Grandpa', italian: 'Nonno', emoji: '👴', category: 'family'),
    VocabularyWord(id: 'fm7', english: 'Baby', italian: 'Bebè', emoji: '👶', category: 'family'),
    VocabularyWord(id: 'fm8', english: 'Uncle', italian: 'Zio', emoji: '👨', category: 'family'),
    VocabularyWord(id: 'fm9', english: 'Aunt', italian: 'Zia', emoji: '👩', category: 'family'),
    VocabularyWord(id: 'fm10', english: 'Cousin', italian: 'Cugino', emoji: '🧒', category: 'family'),

    // Colors
    VocabularyWord(id: 'c1', english: 'Red', italian: 'Rosso', emoji: '🔴', category: 'colors'),
    VocabularyWord(id: 'c2', english: 'Blue', italian: 'Blu', emoji: '🔵', category: 'colors'),
    VocabularyWord(id: 'c3', english: 'Green', italian: 'Verde', emoji: '🟢', category: 'colors'),
    VocabularyWord(id: 'c4', english: 'Yellow', italian: 'Giallo', emoji: '🟡', category: 'colors'),
    VocabularyWord(id: 'c5', english: 'Orange', italian: 'Arancione', emoji: '🟠', category: 'colors'),
    VocabularyWord(id: 'c6', english: 'Purple', italian: 'Viola', emoji: '🟣', category: 'colors'),
    VocabularyWord(id: 'c7', english: 'Pink', italian: 'Rosa', emoji: '💗', category: 'colors'),
    VocabularyWord(id: 'c8', english: 'White', italian: 'Bianco', emoji: '⬜', category: 'colors'),
    VocabularyWord(id: 'c9', english: 'Black', italian: 'Nero', emoji: '⬛', category: 'colors'),
    VocabularyWord(id: 'c10', english: 'Brown', italian: 'Marrone', emoji: '🟤', category: 'colors'),

    // Numbers
    VocabularyWord(id: 'n1', english: 'One', italian: 'Uno', emoji: '1️⃣', category: 'numbers'),
    VocabularyWord(id: 'n2', english: 'Two', italian: 'Due', emoji: '2️⃣', category: 'numbers'),
    VocabularyWord(id: 'n3', english: 'Three', italian: 'Tre', emoji: '3️⃣', category: 'numbers'),
    VocabularyWord(id: 'n4', english: 'Four', italian: 'Quattro', emoji: '4️⃣', category: 'numbers'),
    VocabularyWord(id: 'n5', english: 'Five', italian: 'Cinque', emoji: '5️⃣', category: 'numbers'),
    VocabularyWord(id: 'n6', english: 'Six', italian: 'Sei', emoji: '6️⃣', category: 'numbers'),
    VocabularyWord(id: 'n7', english: 'Seven', italian: 'Sette', emoji: '7️⃣', category: 'numbers'),
    VocabularyWord(id: 'n8', english: 'Eight', italian: 'Otto', emoji: '8️⃣', category: 'numbers'),
    VocabularyWord(id: 'n9', english: 'Nine', italian: 'Nove', emoji: '9️⃣', category: 'numbers'),
    VocabularyWord(id: 'n10', english: 'Ten', italian: 'Dieci', emoji: '🔟', category: 'numbers'),

    // Body
    VocabularyWord(id: 'b1', english: 'Head', italian: 'Testa', emoji: '🗣️', category: 'body'),
    VocabularyWord(id: 'b2', english: 'Hand', italian: 'Mano', emoji: '✋', category: 'body'),
    VocabularyWord(id: 'b3', english: 'Foot', italian: 'Piede', emoji: '🦶', category: 'body'),
    VocabularyWord(id: 'b4', english: 'Eye', italian: 'Occhio', emoji: '👁️', category: 'body'),
    VocabularyWord(id: 'b5', english: 'Ear', italian: 'Orecchio', emoji: '👂', category: 'body'),
    VocabularyWord(id: 'b6', english: 'Nose', italian: 'Naso', emoji: '👃', category: 'body'),
    VocabularyWord(id: 'b7', english: 'Mouth', italian: 'Bocca', emoji: '👄', category: 'body'),
    VocabularyWord(id: 'b8', english: 'Heart', italian: 'Cuore', emoji: '❤️', category: 'body'),
    VocabularyWord(id: 'b9', english: 'Arm', italian: 'Braccio', emoji: '💪', category: 'body'),
    VocabularyWord(id: 'b10', english: 'Leg', italian: 'Gamba', emoji: '🦵', category: 'body'),

    // Greetings
    VocabularyWord(id: 'g1', english: 'Hello', italian: 'Ciao', emoji: '👋', category: 'greetings'),
    VocabularyWord(id: 'g2', english: 'Goodbye', italian: 'Arrivederci', emoji: '👋', category: 'greetings'),
    VocabularyWord(id: 'g3', english: 'Please', italian: 'Per favore', emoji: '🙏', category: 'greetings'),
    VocabularyWord(id: 'g4', english: 'Thank you', italian: 'Grazie', emoji: '😊', category: 'greetings'),
    VocabularyWord(id: 'g5', english: 'Good morning', italian: 'Buongiorno', emoji: '🌅', category: 'greetings'),
    VocabularyWord(id: 'g6', english: 'Good night', italian: 'Buonanotte', emoji: '🌙', category: 'greetings'),
    VocabularyWord(id: 'g7', english: 'Yes', italian: 'Sì', emoji: '✅', category: 'greetings'),
    VocabularyWord(id: 'g8', english: 'No', italian: 'No', emoji: '❌', category: 'greetings'),
    VocabularyWord(id: 'g9', english: 'Sorry', italian: 'Scusa', emoji: '😔', category: 'greetings'),
    VocabularyWord(id: 'g10', english: "You're welcome", italian: 'Prego', emoji: '😄', category: 'greetings'),

    // Nature
    VocabularyWord(id: 'na1', english: 'Sun', italian: 'Sole', emoji: '☀️', category: 'nature'),
    VocabularyWord(id: 'na2', english: 'Moon', italian: 'Luna', emoji: '🌙', category: 'nature'),
    VocabularyWord(id: 'na3', english: 'Star', italian: 'Stella', emoji: '⭐', category: 'nature'),
    VocabularyWord(id: 'na4', english: 'Tree', italian: 'Albero', emoji: '🌳', category: 'nature'),
    VocabularyWord(id: 'na5', english: 'Flower', italian: 'Fiore', emoji: '🌸', category: 'nature'),
    VocabularyWord(id: 'na6', english: 'Rain', italian: 'Pioggia', emoji: '🌧️', category: 'nature'),
    VocabularyWord(id: 'na7', english: 'Snow', italian: 'Neve', emoji: '❄️', category: 'nature'),
    VocabularyWord(id: 'na8', english: 'Sea', italian: 'Mare', emoji: '🌊', category: 'nature'),
    VocabularyWord(id: 'na9', english: 'Mountain', italian: 'Montagna', emoji: '🏔️', category: 'nature'),
    VocabularyWord(id: 'na10', english: 'Cloud', italian: 'Nuvola', emoji: '☁️', category: 'nature'),
  ];

  static List<VocabularyWord> getWordsForCategory(String categoryId) {
    return allWords.where((w) => w.category == categoryId).toList();
  }

  static Category? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (_) {
      return null;
    }
  }
}
