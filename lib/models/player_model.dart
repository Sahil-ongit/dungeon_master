class PlayerModel {
  final String uid;
  final String username;
  final int level;
  final int xp;
  final int gold;

  PlayerModel({
    required this.uid,
    required this.username,
    required this.level,
    required this.xp,
    required this.gold,
  });

  // Convert Firestore document to PlayerModel
  factory PlayerModel.fromMap(Map<String, dynamic> data, String uid) {
    return PlayerModel(
      uid: uid,
      username: data['username'] ?? 'Adventurer',
      level: data['level'] ?? 1,
      xp: data['xp'] ?? 0,
      gold: data['gold'] ?? 100,
    );
  }

  // Convert PlayerModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'level': level,
      'xp': xp,
      'gold': gold,
    };
  }
}