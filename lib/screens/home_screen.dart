import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart'; // <-- Make sure this path is correct

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? playerData;
  bool isLoading = true;

  late AnimationController _controller;
  late Animation<Offset> _floatAnimation;

  @override
  void initState() {
    super.initState();
    setupAnimation();
    fetchPlayerData();
  }

  void setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> fetchPlayerData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('players').doc(user.uid).get();

    if (doc.exists) {
      setState(() {
        playerData = doc.data();
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await AuthService().signOut(); // Sign out from Firebase + Google
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.deepPurple.shade900,
        title: Center(child: const Text('🧙‍♂️ Dungeon Master')),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : playerData == null
                ? const Text("Failed to load player data.")
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SlideTransition(
                        position: _floatAnimation,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/Wizard_bg.png',
                            height: 150,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Welcome, ${user?.displayName ?? 'Adventurer'}!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        color: Colors.deepPurple.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              _buildStatRow("🎖️ Level", playerData!['level'].toString()),
                              _buildStatRow("🧪 XP", playerData!['xp'].toString()),
                              _buildStatRow("💰 Gold", playerData!['gold'].toString()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          // TODO: Add your start action here
                          Navigator.pushNamed(context, '/adventure'); // or any route
                        },
                        child: const Text("Start"),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, color: Colors.white)),
          Text(value, style: const TextStyle(fontSize: 18, color: Colors.white)),
        ],
      ),
    );
  }
}
