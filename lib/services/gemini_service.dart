import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: 'AIzaSyAtRwGnJBseNwTn9RRX3-PPHkfatv0BEns',
  );

  Future<String> generateStory({
    required String userChoice,
    required int hp,
    required int xp,
    required List<String> inventory,
  }) async {
    final prompt = '''
You are a Dungeon Master in a text-based pixel RPG game.

Game State:
- Player HP: $hp
- Player XP: $xp
- Inventory: ${inventory.isEmpty ? 'Empty' : inventory.join(', ')}

Player chose: "$userChoice"

Your job:
1. Continue the storyline with a short, vivid one-liner.
2. Respond appropriately to the player's choice (e.g., if they used a potion, restore HP).
3. If HP is low (<30), hint that the player should heal.
4. Optionally add an item, gold, or enemy to inventory changes.
5. Provide 3 new RPG-style choices (numbered) that match the updated situation.

Keep total lines to 4 or less. Keep it dynamic, fun, and surprising.
''';

    final content = [Content.text(prompt)];

    try {
      final response = await _model.generateContent(content);
      print("🧠 Gemini raw response: ${response.text}");
      return response.text ?? "No story generated.";
    } catch (e) {
      print("❌ Gemini error: $e");
      return "⚠️ Gemini is currently overloaded. Please try again in a moment.";
    }
  }
}
