import 'package:flutter/material.dart';

class BattleScreen extends StatelessWidget {
  const BattleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("⚔️ Battle Arena"),
        backgroundColor: Colors.deepPurple.shade900,
      ),
      body: const Center(
        child: Text(
          "Prepare for battle, brave one!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
