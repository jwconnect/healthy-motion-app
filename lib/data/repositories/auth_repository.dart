import 'package:get/get.dart';
import '../models/user_model.dart';
import '../datasources/local/local_storage.dart';

class AuthRepository {
  final LocalStorage _localStorage = Get.find<LocalStorage>();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<void> init() async {
    final userData = _localStorage.getUser();
    if (userData != null) {
      _currentUser = UserModel.fromJson(userData);
    }
  }

  Future<UserModel> login(String email, String password) async {
    // 실제 구현에서는 API 호출
    // 데모용 더미 데이터
    await Future.delayed(const Duration(seconds: 1));

    final user = UserModel(
      id: '1',
      email: email,
      nickname: '사용자',
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );

    _currentUser = user;
    await _localStorage.setUser(user.toJson());
    await _localStorage.setAccessToken('demo_token');

    return user;
  }

  Future<UserModel> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      nickname: nickname,
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    await _localStorage.setUser(user.toJson());
    await _localStorage.setAccessToken('demo_token');

    return user;
  }

  Future<void> logout() async {
    _currentUser = null;
    await _localStorage.clearTokens();
    await _localStorage.clearUser();
  }

  Future<void> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    // 실제 구현에서는 비밀번호 재설정 이메일 발송
  }

  Future<UserModel> updateProfile({
    String? nickname,
    String? bio,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) {
      throw Exception('로그인이 필요합니다');
    }

    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = _currentUser!.copyWith(
      nickname: nickname ?? _currentUser!.nickname,
      bio: bio ?? _currentUser!.bio,
      profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
    );

    await _localStorage.setUser(_currentUser!.toJson());

    return _currentUser!;
  }

  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(seconds: 1));
    await logout();
  }
}
