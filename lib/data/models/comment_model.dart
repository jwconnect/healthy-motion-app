import 'user_model.dart';

class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final UserModel? user;
  final String content;
  final String? parentCommentId;
  final int likeCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isLiked;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.user,
    required this.content,
    this.parentCommentId,
    this.likeCount = 0,
    required this.createdAt,
    this.updatedAt,
    this.isLiked = false,
    this.replies = const [],
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as String,
      postId: json['postId'] as String,
      userId: json['userId'] as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      content: json['content'] as String,
      parentCommentId: json['parentCommentId'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isLiked: json['isLiked'] as bool? ?? false,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'user': user?.toJson(),
      'content': content,
      'parentCommentId': parentCommentId,
      'likeCount': likeCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isLiked': isLiked,
      'replies': replies.map((e) => e.toJson()).toList(),
    };
  }

  CommentModel copyWith({
    String? id,
    String? postId,
    String? userId,
    UserModel? user,
    String? content,
    String? parentCommentId,
    int? likeCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      content: content ?? this.content,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }

  bool get isReply => parentCommentId != null;
  bool get hasReplies => replies.isNotEmpty;
  int get replyCount => replies.length;
}
