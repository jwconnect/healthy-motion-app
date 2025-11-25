import 'user_model.dart';

class PostModel {
  final String id;
  final String userId;
  final UserModel? user;
  final String category;
  final String? title;
  final String content;
  final List<String> imageUrls;
  final String? videoUrl;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isLiked;
  final bool isBookmarked;

  PostModel({
    required this.id,
    required this.userId,
    this.user,
    required this.category,
    this.title,
    required this.content,
    this.imageUrls = const [],
    this.videoUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      category: json['category'] as String,
      title: json['title'] as String?,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'user': user?.toJson(),
      'category': category,
      'title': title,
      'content': content,
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }

  PostModel copyWith({
    String? id,
    String? userId,
    UserModel? user,
    String? category,
    String? title,
    String? content,
    List<String>? imageUrls,
    String? videoUrl,
    int? likeCount,
    int? commentCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    bool? isBookmarked,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      category: category ?? this.category,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  String get categoryText {
    final categoryMap = {
      'certification': '인증',
      'question': '질문',
      'tip': '팁 공유',
      'free': '자유',
    };
    return categoryMap[category.toLowerCase()] ?? category;
  }

  bool get hasImages => imageUrls.isNotEmpty;
  bool get hasVideo => videoUrl != null;
  bool get hasMedia => hasImages || hasVideo;
}
