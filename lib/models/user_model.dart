/// User model for authentication and profile.
class UserModel {
  final String id;
  final String name;
  final String email;
  final int totalPoints;
  final int streakDays;
  final DateTime joinDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.totalPoints = 0,
    this.streakDays = 0,
    required this.joinDate,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? totalPoints,
    int? streakDays,
    DateTime? joinDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      joinDate: joinDate ?? this.joinDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'totalPoints': totalPoints,
    'streakDays': streakDays,
    'joinDate': joinDate.toIso8601String(),
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    totalPoints: json['totalPoints'] as int? ?? 0,
    streakDays: json['streakDays'] as int? ?? 0,
    joinDate: DateTime.parse(json['joinDate'] as String),
  );
}
