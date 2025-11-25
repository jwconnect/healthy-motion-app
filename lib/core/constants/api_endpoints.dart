class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://api.healthymotion.com/api';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Users
  static const String userMe = '/users/me';
  static String userById(String id) => '/users/$id';
  static String followUser(String id) => '/users/$id/follow';

  // Motions
  static const String motions = '/motions';
  static String motionById(String id) => '/motions/$id';
  static const String recommendedMotions = '/motions/recommended';
  static String likeMotion(String id) => '/motions/$id/like';
  static String viewMotion(String id) => '/motions/$id/view';

  // Routines
  static const String routines = '/routines';
  static const String officialRoutines = '/routines/official';
  static String routineById(String id) => '/routines/$id';

  // Records
  static const String records = '/records';
  static const String recordStatistics = '/records/statistics';
  static const String recordStreak = '/records/streak';

  // Community
  static const String posts = '/posts';
  static String postById(String id) => '/posts/$id';
  static String likePost(String id) => '/posts/$id/like';
  static String postComments(String id) => '/posts/$id/comments';
  static String commentById(String id) => '/comments/$id';

  // Notifications
  static const String notifications = '/notifications';
  static String readNotification(String id) => '/notifications/$id/read';
  static const String readAllNotifications = '/notifications/read-all';
}
