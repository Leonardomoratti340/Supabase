class UserProfile {
  final String id;
  final String username;
  final String? avatarUrl;
  final DateTime birthdate;

  UserProfile({
    required this.id,
    required this.username,
    required this.birthdate,
    this.avatarUrl
  });

  int get age {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month || (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      username: map['username'],
      avatarUrl: map['avatar_url'], 
      birthdate: DateTime.parse(map['birthdate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'birthdate': birthdate.toIso8601String(),
    };
  }
}