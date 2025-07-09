import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../models/story_model.dart';

class StorylineScreen extends StatefulWidget {
  const StorylineScreen({super.key});

  @override
  State<StorylineScreen> createState() => _StorylineScreenState();
}

class _StorylineScreenState extends State<StorylineScreen> {
  final GeminiService _gemini = GeminiService();

  List<Map<String, dynamic>> chat = [];
  List<String> currentOptions = [];
  int xp = 0;
  int hp = 100;
  List<String> inventory = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStory("Start your journey.");
  }

  void _loadStory(String userChoice) async {
    setState(() {
      isLoading = true;
      currentOptions = [];
    });

    // Log user choice
    if (chat.isNotEmpty) {
      chat.add({'type': 'user', 'text': userChoice});
    }

    // Simulate using potion
    if (userChoice.toLowerCase().contains("potion")) {
      if (inventory.contains("Healing Potion")) {
        hp = (hp + 30).clamp(0, 100);
        inventory.remove("Healing Potion");
        chat.add({'type': 'system', 'text': "🧪 You used a Healing Potion. HP +30!"});
      } else {
        chat.add({'type': 'system', 'text': "⚠️ You don't have any potions!"});
      }
    }

    final geminiResponse = await _gemini.generateStory(
      userChoice: userChoice,
      hp: hp,
      xp: xp,
      inventory: inventory,
    );

    final segment = _parseResponse(geminiResponse);

    // Try detecting new item from response
    for (final item in ["Sword", "Shield", "Gold", "Healing Potion"]) {
      if (geminiResponse.contains(item) && !inventory.contains(item)) {
        inventory.add(item);
        chat.add({'type': 'system', 'text': "🎒 You obtained: $item"});
      }
    }

    setState(() {
      chat.add({'type': 'bot', 'text': segment.text});
      currentOptions = segment.options;
      xp += 10;
      hp = (hp - 5).clamp(0, 100);
      isLoading = false;
    });
  }

  StorySegment _parseResponse(String response) {
    final lines = response
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    final story = lines.first;
    final choices = lines
        .skip(1)
        .take(3)
        .map((line) => line.replaceFirst(RegExp(r'^[0-9]+\.\s*'), '').trim())
        .toList();

    return StorySegment(text: story, options: choices);
  }

  Widget _buildMessage(String text, String type) {
    Color bgColor = Colors.grey.shade800;
    Alignment align = Alignment.centerLeft;

    if (type == 'user') {
      bgColor = Colors.deepPurple.shade700;
      align = Alignment.centerRight;
    } else if (type == 'system') {
      bgColor = Colors.blueGrey;
      align = Alignment.center;
    }

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stat("XP", xp.toString()),
        _stat("HP", "$hp ❤️"),
        _stat("Bag", inventory.isEmpty ? "Empty" : inventory.join(", ")),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("📜 Storyline"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatsBar(),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  final message = chat[index];
                  return _buildMessage(message['text'], message['type']);
                },
              ),
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const Text(
                "Loading response...",
                style: TextStyle(color: Colors.grey),
              ),
            if (!isLoading)
              Column(
                children: currentOptions.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.all(12),
                      ),
                      onPressed: () => _loadStory(opt),
                      child: Text(opt, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
