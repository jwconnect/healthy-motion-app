import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/post_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/repositories/community_repository.dart';
import '../../core/utils/helpers.dart';

class CommunityController extends GetxController {
  final CommunityRepository _repository = Get.find<CommunityRepository>();

  final posts = <PostModel>[].obs;
  final popularPosts = <PostModel>[].obs;
  final comments = <CommentModel>[].obs;
  final isLoading = false.obs;
  final isLoadingComments = false.obs;
  final selectedPost = Rx<PostModel?>(null);
  final selectedCategory = 'all'.obs;

  // 글쓰기용
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final selectedPostCategory = 'free'.obs;
  final selectedImages = <String>[].obs;

  // 댓글용
  final commentController = TextEditingController();
  final replyingToComment = Rx<CommentModel?>(null);

  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
    fetchPopularPosts();
  }

  @override
  void onClose() {
    titleController.dispose();
    contentController.dispose();
    commentController.dispose();
    super.onClose();
  }

  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
    }

    if (!_hasMore && !refresh) return;

    isLoading.value = true;
    try {
      final result = await _repository.getPosts(
        category: selectedCategory.value == 'all' ? null : selectedCategory.value,
        page: _currentPage,
      );

      if (refresh || _currentPage == 1) {
        posts.assignAll(result);
      } else {
        posts.addAll(result);
      }

      _hasMore = result.length >= 20;
      if (result.isNotEmpty) _currentPage++;
    } catch (e) {
      Helpers.showSnackBar('게시글을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPopularPosts() async {
    try {
      final result = await _repository.getPopularPosts();
      popularPosts.assignAll(result);
    } catch (e) {
      // 인기 게시글 로딩 실패는 조용히 처리
    }
  }

  Future<void> fetchPostById(String id) async {
    isLoading.value = true;
    try {
      final post = await _repository.getPostById(id);
      selectedPost.value = post;
      if (post != null) {
        await fetchComments(id);
      }
    } catch (e) {
      Helpers.showSnackBar('게시글을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void setPost(PostModel post) {
    selectedPost.value = post;
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    fetchPosts(refresh: true);
  }

  Future<void> createPost() async {
    final content = contentController.text.trim();

    if (content.isEmpty) {
      Helpers.showSnackBar('내용을 입력해주세요', isError: true);
      return;
    }

    isLoading.value = true;
    try {
      await _repository.createPost(
        category: selectedPostCategory.value,
        title: titleController.text.trim().isEmpty ? null : titleController.text.trim(),
        content: content,
        imageUrls: selectedImages.toList(),
      );
      Helpers.showSuccessSnackBar('게시글이 등록되었습니다');
      clearPostForm();
      await fetchPosts(refresh: true);
      Get.back();
    } catch (e) {
      Helpers.showSnackBar('게시글 등록에 실패했습니다', isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void clearPostForm() {
    titleController.clear();
    contentController.clear();
    selectedPostCategory.value = 'free';
    selectedImages.clear();
  }

  Future<void> deletePost(String id) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '게시글 삭제',
      message: '이 게시글을 삭제하시겠습니까?',
      confirmText: '삭제',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        await _repository.deletePost(id);
        Helpers.showSuccessSnackBar('게시글이 삭제되었습니다');
        await fetchPosts(refresh: true);
        Get.back();
      } catch (e) {
        Helpers.showSnackBar('게시글 삭제에 실패했습니다', isError: true);
      }
    }
  }

  Future<void> toggleLike(String postId) async {
    final index = posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = posts[index];
    final newIsLiked = !post.isLiked;

    // Optimistic update
    posts[index] = post.copyWith(
      isLiked: newIsLiked,
      likeCount: newIsLiked ? post.likeCount + 1 : post.likeCount - 1,
    );

    if (selectedPost.value?.id == postId) {
      selectedPost.value = posts[index];
    }

    try {
      if (newIsLiked) {
        await _repository.likePost(postId);
      } else {
        await _repository.unlikePost(postId);
      }
    } catch (e) {
      // Rollback on error
      posts[index] = post;
      if (selectedPost.value?.id == postId) {
        selectedPost.value = post;
      }
      Helpers.showSnackBar('좋아요 처리에 실패했습니다', isError: true);
    }
  }

  // 댓글
  Future<void> fetchComments(String postId) async {
    isLoadingComments.value = true;
    try {
      final result = await _repository.getComments(postId);
      comments.assignAll(result);
    } catch (e) {
      Helpers.showSnackBar('댓글을 불러오는데 실패했습니다', isError: true);
    } finally {
      isLoadingComments.value = false;
    }
  }

  Future<void> createComment() async {
    final content = commentController.text.trim();
    final postId = selectedPost.value?.id;

    if (content.isEmpty || postId == null) return;

    try {
      await _repository.createComment(
        postId: postId,
        content: content,
        parentCommentId: replyingToComment.value?.id,
      );
      commentController.clear();
      replyingToComment.value = null;
      await fetchComments(postId);

      // 댓글 수 업데이트
      if (selectedPost.value != null) {
        selectedPost.value = selectedPost.value!.copyWith(
          commentCount: selectedPost.value!.commentCount + 1,
        );
      }
    } catch (e) {
      Helpers.showSnackBar('댓글 등록에 실패했습니다', isError: true);
    }
  }

  void startReply(CommentModel comment) {
    replyingToComment.value = comment;
  }

  void cancelReply() {
    replyingToComment.value = null;
  }

  Future<void> deleteComment(String commentId) async {
    final confirmed = await Helpers.showConfirmDialog(
      title: '댓글 삭제',
      message: '이 댓글을 삭제하시겠습니까?',
      confirmText: '삭제',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        await _repository.deleteComment(commentId);
        await fetchComments(selectedPost.value!.id);
      } catch (e) {
        Helpers.showSnackBar('댓글 삭제에 실패했습니다', isError: true);
      }
    }
  }

  void addImage(String imagePath) {
    if (selectedImages.length < 5) {
      selectedImages.add(imagePath);
    } else {
      Helpers.showSnackBar('이미지는 최대 5장까지 첨부할 수 있습니다', isError: true);
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> refresh() async {
    await fetchPosts(refresh: true);
    await fetchPopularPosts();
  }

  Future<void> loadMore() async {
    if (!isLoading.value && _hasMore) {
      await fetchPosts();
    }
  }
}
