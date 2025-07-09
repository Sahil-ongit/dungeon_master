import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🎒 Inventory"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: const Center(
        child: Text(
          "Your legendary loot appears here.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
