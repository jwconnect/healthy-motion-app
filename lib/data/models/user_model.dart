class UserModel {
  final String id;
  final String email;
  final String nickname;
  final String? profileImageUrl;
  final String? bio;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final int totalExerciseMinutes;
  final int streakDays;
  final List<String> badges;
  final int followerCount;
  final int followingCount;
  final bool isGuest;

  UserModel({
    required this.id,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
    this.lastLoginAt,
    this.totalExerciseMinutes = 0,
    this.streakDays = 0,
    this.badges = const [],
    this.followerCount = 0,
    this.followingCount = 0,
    this.isGuest = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      totalExerciseMinutes: json['totalExerciseMinutes'] as int? ?? 0,
      streakDays: json['streakDays'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      followerCount: json['followerCount'] as int? ?? 0,
      followingCount: json['followingCount'] as int? ?? 0,
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nickname': nickname,
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'totalExerciseMinutes': totalExerciseMinutes,
      'streakDays': streakDays,
      'badges': badges,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'isGuest': isGuest,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? nickname,
    String? profileImageUrl,
    String? bio,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    int? totalExerciseMinutes,
    int? streakDays,
    List<String>? badges,
    int? followerCount,
    int? followingCount,
    bool? isGuest,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      totalExerciseMinutes: totalExerciseMinutes ?? this.totalExerciseMinutes,
      streakDays: streakDays ?? this.streakDays,
      badges: badges ?? this.badges,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  static UserModel empty() {
    return UserModel(
      id: '',
      email: '',
      nickname: '',
      createdAt: DateTime.now(),
    );
  }
}
