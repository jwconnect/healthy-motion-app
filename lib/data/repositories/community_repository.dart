import '../models/post_model.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';

class CommunityRepository {
  final List<PostModel> _posts = [
    PostModel(
      id: '1',
      userId: 'user1',
      user: UserModel(
        id: 'user1',
        email: 'user1@example.com',
        nickname: '운동러버',
        profileImageUrl: 'https://picsum.photos/seed/user1/100/100',
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
      category: 'certification',
      title: '30일 스트레칭 챌린지 완료!',
      content: '드디어 30일 연속으로 스트레칭을 완료했습니다! 처음에는 힘들었는데 이제는 습관이 되었어요. 목과 어깨 통증도 많이 줄었습니다.',
      imageUrls: ['https://picsum.photos/seed/post1/400/300'],
      likeCount: 42,
      commentCount: 8,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: '2',
      userId: 'user2',
      user: UserModel(
        id: 'user2',
        email: 'user2@example.com',
        nickname: '건강지킴이',
        profileImageUrl: 'https://picsum.photos/seed/user2/100/100',
        createdAt: DateTime.now().subtract(const Duration(days: 50)),
      ),
      category: 'tip',
      title: '목 스트레칭 꿀팁 공유합니다',
      content: '업무 중 1시간마다 목 스트레칭을 하면 거북목 예방에 정말 효과적이에요. 알람을 맞춰두고 하시는 걸 추천드려요!',
      likeCount: 28,
      commentCount: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    PostModel(
      id: '3',
      userId: 'user3',
      user: UserModel(
        id: 'user3',
        email: 'user3@example.com',
        nickname: '헬스초보',
        profileImageUrl: 'https://picsum.photos/seed/user3/100/100',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      category: 'question',
      title: '허리 스트레칭할 때 통증이 있어요',
      content: '허리 비틀기 동작을 할 때 약간 통증이 있는데 계속해도 될까요? 아니면 다른 동작으로 대체하는 게 좋을까요?',
      likeCount: 5,
      commentCount: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      id: '4',
      userId: 'user4',
      user: UserModel(
        id: 'user4',
        email: 'user4@example.com',
        nickname: '아침형인간',
        profileImageUrl: 'https://picsum.photos/seed/user4/100/100',
        createdAt: DateTime.now().subtract(const Duration(days: 80)),
      ),
      category: 'certification',
      content: '오늘도 아침 스트레칭 완료! 매일 일어나자마자 5분 스트레칭하니까 하루가 개운하게 시작돼요 ☀️',
      imageUrls: [
        'https://picsum.photos/seed/post4a/400/300',
        'https://picsum.photos/seed/post4b/400/300',
      ],
      likeCount: 67,
      commentCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PostModel(
      id: '5',
      userId: 'user5',
      user: UserModel(
        id: 'user5',
        email: 'user5@example.com',
        nickname: '직장인스트레처',
        profileImageUrl: 'https://picsum.photos/seed/user5/100/100',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      category: 'free',
      title: '재택근무하면서 운동하기',
      content: '재택근무 시작하고 나서 운동량이 확 줄었는데, 이 앱 덕분에 틈틈이 스트레칭하고 있어요. 같은 재택러분들 화이팅!',
      likeCount: 34,
      commentCount: 7,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  final Map<String, List<CommentModel>> _comments = {
    '1': [
      CommentModel(
        id: 'c1',
        postId: '1',
        userId: 'user2',
        user: UserModel(
          id: 'user2',
          email: 'user2@example.com',
          nickname: '건강지킴이',
          profileImageUrl: 'https://picsum.photos/seed/user2/100/100',
          createdAt: DateTime.now().subtract(const Duration(days: 50)),
        ),
        content: '정말 대단하세요! 저도 도전해볼게요 💪',
        likeCount: 5,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      CommentModel(
        id: 'c2',
        postId: '1',
        userId: 'user3',
        user: UserModel(
          id: 'user3',
          email: 'user3@example.com',
          nickname: '헬스초보',
          profileImageUrl: 'https://picsum.photos/seed/user3/100/100',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        content: '어떤 루틴으로 하셨어요?',
        likeCount: 2,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ],
  };

  Future<List<PostModel>> getPosts({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var result = List<PostModel>.from(_posts);

    if (category != null && category.isNotEmpty && category != 'all') {
      result = result.where((p) => p.category == category).toList();
    }

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;

    if (startIndex >= result.length) return [];
    return result.sublist(
      startIndex,
      endIndex > result.length ? result.length : endIndex,
    );
  }

  Future<PostModel?> getPostById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<PostModel> createPost({
    required String category,
    String? title,
    required String content,
    List<String> imageUrls = const [],
    String? videoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final post = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      user: UserModel(
        id: 'current_user',
        email: 'user@example.com',
        nickname: '나',
        createdAt: DateTime.now(),
      ),
      category: category,
      title: title,
      content: content,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
      createdAt: DateTime.now(),
    );

    _posts.insert(0, post);
    return post;
  }

  Future<void> deletePost(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _posts.removeWhere((p) => p.id == id);
  }

  Future<void> likePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        isLiked: true,
        likeCount: _posts[index].likeCount + 1,
      );
    }
  }

  Future<void> unlikePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      _posts[index] = _posts[index].copyWith(
        isLiked: false,
        likeCount: _posts[index].likeCount - 1,
      );
    }
  }

  Future<List<CommentModel>> getComments(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _comments[postId] ?? [];
  }

  Future<CommentModel> createComment({
    required String postId,
    required String content,
    String? parentCommentId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final comment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: postId,
      userId: 'current_user',
      user: UserModel(
        id: 'current_user',
        email: 'user@example.com',
        nickname: '나',
        createdAt: DateTime.now(),
      ),
      content: content,
      parentCommentId: parentCommentId,
      createdAt: DateTime.now(),
    );

    _comments.putIfAbsent(postId, () => []).add(comment);

    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex != -1) {
      _posts[postIndex] = _posts[postIndex].copyWith(
        commentCount: _posts[postIndex].commentCount + 1,
      );
    }

    return comment;
  }

  Future<void> deleteComment(String commentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final comments in _comments.values) {
      comments.removeWhere((c) => c.id == commentId);
    }
  }

  Future<List<PostModel>> getPopularPosts({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final sorted = List<PostModel>.from(_posts)
      ..sort((a, b) => b.likeCount.compareTo(a.likeCount));
    return sorted.take(limit).toList();
  }
}
