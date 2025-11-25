# 건강한 동작 (Healthy Motion) - Flutter 앱 명세서

## 1. 앱 개요

### 1.1 앱 이름
- 한글: **건강한 동작**
- 영문: **Healthy Motion**
- 패키지명: `com.healthymotion.app`

### 1.2 앱 목적
일상에서 쉽게 따라할 수 있는 스트레칭, 자세 교정, 건강 운동 동작을 **영상 콘텐츠** 중심으로 제공하고, **커뮤니티**를 통해 사용자 간 경험을 공유하는 헬스케어 앱

### 1.3 타겟 사용자
- 오래 앉아있는 직장인/학생
- 거북목, 허리 통증 등 자세 문제가 있는 사람
- 가볍게 운동하고 싶은 일반인
- 재활/스트레칭이 필요한 사람

### 1.4 핵심 가치
- **쉬운 접근성**: 언제 어디서나 따라할 수 있는 동작
- **영상 중심**: 전문가의 시범 영상으로 정확한 동작 학습
- **커뮤니티**: 사용자 간 동기부여 및 경험 공유
- **개인화**: 나만의 루틴 구성 및 기록 관리

---

## 2. 기술 스택

### 2.1 Frontend
```
Framework: Flutter 3.x (Latest Stable)
Language: Dart
State Management: GetX 4.x
```

### 2.2 Backend (권장)
```
Option A: Firebase (빠른 개발)
  - Firebase Auth (인증)
  - Cloud Firestore (데이터베이스)
  - Firebase Storage (영상/이미지 저장)
  - Firebase Cloud Messaging (푸시 알림)

Option B: Custom Backend
  - Server: Node.js + Express 또는 Spring Boot
  - Database: PostgreSQL / MongoDB
  - Storage: AWS S3 / Google Cloud Storage
```

### 2.3 주요 Flutter 패키지
```yaml
dependencies:
  # 상태관리 & 라우팅 & 의존성 주입
  get: ^4.6.6
  
  # 네트워크/API
  dio: ^5.3.0
  
  # 영상 플레이어
  video_player: ^2.8.0
  chewie: ^1.7.0  # 영상 플레이어 UI
  youtube_player_flutter: ^8.1.2  # YouTube 영상 지원
  
  # 로컬 저장소
  shared_preferences: ^2.2.0
  hive: ^2.2.3  # 로컬 DB
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  firebase_storage: ^11.6.0
  firebase_messaging: ^14.7.0
  
  # UI/UX
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0  # 로딩 효과
  lottie: ^2.7.0  # 애니메이션
  flutter_svg: ^2.0.9
  
  # 기타
  intl: ^0.18.0  # 날짜/시간 포맷
  permission_handler: ^11.1.0
  share_plus: ^7.2.0  # 공유 기능
  image_picker: ^1.0.0
  
  # 알림
  flutter_local_notifications: ^16.2.0
```

---

## 3. GetX 아키텍처 가이드

### 3.1 GetX 주요 기능 활용
```dart
// GetX는 3가지 핵심 기능을 제공합니다:
// 1. 상태 관리 (State Management)
// 2. 라우트 관리 (Route Management)
// 3. 의존성 주입 (Dependency Injection)
```

### 3.2 Controller 패턴 예시
```dart
// lib/presentation/controllers/motion_controller.dart
import 'package:get/get.dart';

class MotionController extends GetxController {
  // Observable 변수 (.obs)
  final motions = <MotionModel>[].obs;
  final isLoading = false.obs;
  final selectedCategory = ''.obs;
  
  // Repository 의존성 주입
  final MotionRepository _repository = Get.find<MotionRepository>();
  
  @override
  void onInit() {
    super.onInit();
    fetchMotions();
  }
  
  // 동작 목록 가져오기
  Future<void> fetchMotions() async {
    isLoading.value = true;
    try {
      final result = await _repository.getMotions();
      motions.assignAll(result);
    } catch (e) {
      Get.snackbar('오류', '동작을 불러오지 못했습니다');
    } finally {
      isLoading.value = false;
    }
  }
  
  // 카테고리 필터링
  void filterByCategory(String category) {
    selectedCategory.value = category;
    // 필터 로직...
  }
}
```

### 3.3 Binding 패턴 예시
```dart
// lib/presentation/bindings/motion_binding.dart
import 'package:get/get.dart';

class MotionBinding extends Bindings {
  @override
  void dependencies() {
    // Controller 등록 (lazy loading)
    Get.lazyPut<MotionController>(() => MotionController());
  }
}
```

### 3.4 라우트 설정 예시
```dart
// lib/routes/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const motionList = '/motions';
  static const motionDetail = '/motions/:id';
  static const motionPlayer = '/motions/:id/play';
  static const routineList = '/routines';
  static const routineCreate = '/routines/create';
  static const routineDetail = '/routines/:id';
  static const routinePlayer = '/routines/:id/play';
  static const community = '/community';
  static const postDetail = '/community/posts/:id';
  static const postCreate = '/community/posts/create';
  static const userProfile = '/users/:id';
  static const profile = '/profile';
  static const editProfile = '/profile/edit';
  static const settings = '/settings';
  static const notifications = '/notifications';
  static const records = '/records';
  static const statistics = '/statistics';
}

// lib/routes/app_pages.dart
import 'package:get/get.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.motionList,
      page: () => const MotionListScreen(),
      binding: MotionBinding(),
    ),
    GetPage(
      name: AppRoutes.motionDetail,
      page: () => const MotionDetailScreen(),
      binding: MotionBinding(),
    ),
    GetPage(
      name: AppRoutes.community,
      page: () => const CommunityScreen(),
      binding: CommunityBinding(),
    ),
    // ... 기타 페이지
  ];
}
```

### 3.5 View에서 Controller 사용 예시
```dart
// lib/presentation/screens/motion/motion_list_screen.dart
import 'package:get/get.dart';

class MotionListScreen extends GetView<MotionController> {
  const MotionListScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('동작 라이브러리')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return ListView.builder(
          itemCount: controller.motions.length,
          itemBuilder: (context, index) {
            final motion = controller.motions[index];
            return MotionCard(
              motion: motion,
              onTap: () => Get.toNamed(
                AppRoutes.motionDetail,
                arguments: motion,
              ),
            );
          },
        );
      }),
    );
  }
}
```

### 3.6 main.dart 설정
```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 초기 의존성 주입
  await initDependencies();
  
  runApp(const MyApp());
}

Future<void> initDependencies() async {
  // Repositories
  Get.put<AuthRepository>(AuthRepository());
  Get.put<MotionRepository>(MotionRepository());
  Get.put<RoutineRepository>(RoutineRepository());
  Get.put<RecordRepository>(RecordRepository());
  Get.put<CommunityRepository>(CommunityRepository());
  
  // Services
  Get.put<NotificationService>(NotificationService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '건강한 동작',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      locale: const Locale('ko', 'KR'),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

### 3.7 GetX 유틸리티 활용
```dart
// 네비게이션
Get.toNamed('/motions');              // 이동
Get.offNamed('/home');                // 이동 (현재 화면 제거)
Get.offAllNamed('/login');            // 모든 스택 제거 후 이동
Get.back();                           // 뒤로 가기
Get.toNamed('/motions/123', arguments: motion);  // 인자 전달

// 인자 받기
final motion = Get.arguments as MotionModel;
final id = Get.parameters['id'];

// 다이얼로그
Get.dialog(AlertDialog(...));
Get.bottomSheet(Container(...));

// 스낵바
Get.snackbar('성공', '저장되었습니다');
Get.snackbar('오류', '실패했습니다', backgroundColor: Colors.red);

// 로딩
Get.dialog(
  const Center(child: CircularProgressIndicator()),
  barrierDismissible: false,
);
Get.back(); // 로딩 닫기
```

---

## 4. 앱 구조 (폴더 구조)

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_sizes.dart
│   │   └── api_endpoints.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validators.dart
│   │   └── helpers.dart
│   └── extensions/
│       └── string_extension.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── motion_model.dart
│   │   ├── category_model.dart
│   │   ├── routine_model.dart
│   │   ├── record_model.dart
│   │   ├── post_model.dart
│   │   └── comment_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── motion_repository.dart
│   │   ├── routine_repository.dart
│   │   ├── record_repository.dart
│   │   └── community_repository.dart
│   └── datasources/
│       ├── remote/
│       │   └── api_client.dart
│       └── local/
│           └── local_storage.dart
│
├── domain/
│   ├── entities/
│   └── usecases/
│
├── presentation/
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── motion_controller.dart
│   │   ├── routine_controller.dart
│   │   ├── record_controller.dart
│   │   └── community_controller.dart
│   │
│   ├── bindings/
│   │   ├── auth_binding.dart
│   │   ├── home_binding.dart
│   │   ├── motion_binding.dart
│   │   ├── routine_binding.dart
│   │   ├── community_binding.dart
│   │   └── profile_binding.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── forgot_password_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── motion/
│   │   │   ├── motion_list_screen.dart
│   │   │   ├── motion_detail_screen.dart
│   │   │   └── motion_player_screen.dart
│   │   ├── routine/
│   │   │   ├── routine_list_screen.dart
│   │   │   ├── routine_detail_screen.dart
│   │   │   ├── routine_create_screen.dart
│   │   │   └── routine_player_screen.dart
│   │   ├── community/
│   │   │   ├── community_screen.dart
│   │   │   ├── post_detail_screen.dart
│   │   │   ├── post_create_screen.dart
│   │   │   └── user_profile_screen.dart
│   │   ├── record/
│   │   │   ├── record_screen.dart
│   │   │   └── statistics_screen.dart
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   ├── edit_profile_screen.dart
│   │   │   └── settings_screen.dart
│   │   └── notification/
│   │       └── notification_screen.dart
│   │
│   └── widgets/
│       ├── common/
│       │   ├── custom_app_bar.dart
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── loading_widget.dart
│       │   └── error_widget.dart
│       ├── motion/
│       │   ├── motion_card.dart
│       │   ├── motion_video_player.dart
│       │   └── category_chip.dart
│       ├── routine/
│       │   ├── routine_card.dart
│       │   └── routine_timer.dart
│       └── community/
│           ├── post_card.dart
│           ├── comment_item.dart
│           └── user_avatar.dart
│
├── routes/
│   ├── app_pages.dart
│   └── app_routes.dart
│
└── services/
    ├── notification_service.dart
    ├── analytics_service.dart
    └── deep_link_service.dart
```

---

## 5. 화면 구성 및 상세 기능

### 5.1 화면 흐름도 (Navigation Flow)

```
[스플래시] → [온보딩] → [로그인/회원가입]
                              ↓
                    [메인 (BottomNavigationBar)]
                    ├── 홈
                    ├── 동작 라이브러리
                    ├── 내 루틴
                    ├── 커뮤니티
                    └── 프로필
```

---

### 5.2 각 화면 상세 명세

#### 📱 Screen 1: 스플래시 (Splash Screen)
**경로**: `/splash`
**파일**: `lib/presentation/screens/splash/splash_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 앱 초기 로딩, 로고 표시, 인증 상태 확인 |
| 구성요소 | 앱 로고, 앱 이름, 로딩 인디케이터 |
| 동작 | 2초 후 자동 전환 (인증 상태에 따라 홈 또는 로그인) |

```dart
// 주요 로직
- 앱 초기화 (Firebase 등)
- 로그인 상태 확인
- 로그인 O → 홈 화면 이동
- 로그인 X → 온보딩/로그인 화면 이동
```

---

#### 📱 Screen 2: 온보딩 (Onboarding Screen)
**경로**: `/onboarding`
**파일**: `lib/presentation/screens/onboarding/onboarding_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 첫 사용자에게 앱 소개 |
| 구성요소 | PageView (3~4페이지), 인디케이터, 건너뛰기/시작 버튼 |
| 페이지 내용 | 1) 앱 소개 2) 영상 가이드 소개 3) 커뮤니티 소개 4) 시작하기 |

---

#### 📱 Screen 3: 로그인 (Login Screen)
**경로**: `/login`
**파일**: `lib/presentation/screens/auth/login_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 사용자 로그인 |
| 구성요소 | 이메일 입력, 비밀번호 입력, 로그인 버튼, 소셜 로그인 |
| 기능 | 이메일 로그인, Google 로그인, Apple 로그인, 비밀번호 찾기 링크 |

```dart
// 입력 필드
- 이메일: TextFormField (이메일 유효성 검사)
- 비밀번호: TextFormField (obscureText: true)

// 버튼
- 로그인 버튼
- Google 로그인 버튼
- Apple 로그인 버튼 (iOS only)
- 회원가입 링크
- 비밀번호 찾기 링크
```

---

#### 📱 Screen 4: 회원가입 (Register Screen)
**경로**: `/register`
**파일**: `lib/presentation/screens/auth/register_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 신규 사용자 가입 |
| 구성요소 | 닉네임, 이메일, 비밀번호, 비밀번호 확인, 약관 동의 |
| 유효성검사 | 이메일 형식, 비밀번호 8자 이상, 비밀번호 일치 확인 |

---

#### 📱 Screen 5: 홈 (Home Screen)
**경로**: `/home` (메인 탭 인덱스 0)
**파일**: `lib/presentation/screens/home/home_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 메인 대시보드, 빠른 접근 |
| 구성요소 | 인사 메시지, 오늘의 추천 동작, 진행 중인 루틴, 인기 게시글 |

```dart
// 섹션 구성
1. 상단 AppBar
   - 앱 로고
   - 알림 아이콘 (Badge)

2. 인사 섹션
   - "안녕하세요, {닉네임}님!"
   - 오늘의 운동 현황 요약

3. 오늘의 추천 동작 (Horizontal ListView)
   - MotionCard 위젯 (썸네일, 제목, 시간)
   - 탭 → 동작 상세 화면

4. 내 루틴 바로가기
   - 진행 중인 루틴 카드
   - "루틴 시작하기" 버튼

5. 인기 커뮤니티 게시글 (2~3개)
   - PostCard 위젯
   - "더보기" → 커뮤니티 탭

6. 오늘의 팁 카드
   - 건강 관련 짧은 팁
```

---

#### 📱 Screen 6: 동작 라이브러리 (Motion List Screen)
**경로**: `/motions` (메인 탭 인덱스 1)
**파일**: `lib/presentation/screens/motion/motion_list_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 모든 운동 동작 탐색 |
| 구성요소 | 검색바, 카테고리 필터, 동작 리스트 |
| 필터 | 부위별, 목적별, 난이도별, 소요시간별 |

```dart
// 카테고리 (Category)
부위별:
  - 목/어깨
  - 허리/등
  - 하체
  - 전신
  - 손목/발목

목적별:
  - 스트레칭
  - 자세교정
  - 통증완화
  - 근력강화
  - 릴렉스

난이도:
  - 초급
  - 중급
  - 고급

소요시간:
  - 5분 이내
  - 5~10분
  - 10~20분
  - 20분 이상

// UI 구성
- 상단: 검색바 (SearchBar)
- 카테고리 칩 (가로 스크롤)
- 그리드 또는 리스트 뷰 (토글 가능)
- MotionCard: 썸네일, 제목, 시간, 난이도, 좋아요 수
```

---

#### 📱 Screen 7: 동작 상세 (Motion Detail Screen)
**경로**: `/motions/:id`
**파일**: `lib/presentation/screens/motion/motion_detail_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 개별 동작 상세 정보 및 영상 시청 |
| 구성요소 | 영상 플레이어, 동작 설명, 주의사항, 관련 동작 |

```dart
// 구성
1. 영상 플레이어 (상단)
   - Chewie 또는 YouTube Player
   - 전체화면 지원
   - 재생/일시정지, 구간 반복

2. 동작 정보
   - 제목
   - 카테고리 태그
   - 난이도 / 소요시간
   - 좋아요 수 / 조회 수

3. 탭 영역
   - [설명] 동작 설명, 효과
   - [방법] 단계별 수행 방법
   - [주의사항] 잘못된 자세, 주의점

4. 액션 버튼
   - 좋아요 버튼
   - 루틴에 추가 버튼
   - 공유 버튼

5. 관련 동작 추천 (하단)
```

---

#### 📱 Screen 8: 동작 플레이어 (Motion Player Screen)
**경로**: `/motions/:id/play`
**파일**: `lib/presentation/screens/motion/motion_player_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 전체 화면 영상 플레이어 (집중 모드) |
| 구성요소 | 전체화면 영상, 타이머, 다음 동작 버튼 |
| 특징 | 화면 꺼짐 방지, 가로/세로 모드 지원 |

---

#### 📱 Screen 9: 내 루틴 목록 (Routine List Screen)
**경로**: `/routines` (메인 탭 인덱스 2)
**파일**: `lib/presentation/screens/routine/routine_list_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 사용자가 만든 루틴 관리 |
| 구성요소 | 루틴 카드 리스트, 추천 루틴, 루틴 만들기 버튼 |

```dart
// 섹션
1. 내 루틴 (사용자 생성)
   - RoutineCard: 제목, 동작 수, 총 시간, 진행률
   - 스와이프로 삭제

2. 추천 루틴 (앱 제공)
   - "아침 스트레칭 5분"
   - "점심시간 목/어깨 풀기"
   - "취침 전 릴렉스"
   
3. FloatingActionButton
   - 새 루틴 만들기
```

---

#### 📱 Screen 10: 루틴 만들기 (Routine Create Screen)
**경로**: `/routines/create`
**파일**: `lib/presentation/screens/routine/routine_create_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 새로운 루틴 생성 |
| 구성요소 | 루틴명 입력, 동작 선택/추가, 순서 조정, 휴식 시간 설정 |

```dart
// 단계
1. 기본 정보 입력
   - 루틴 이름
   - 설명 (선택)
   - 알림 시간 설정 (선택)

2. 동작 추가
   - "동작 추가" 버튼 → 동작 라이브러리 (다중 선택)
   - 드래그 앤 드롭으로 순서 변경
   - 동작 간 휴식 시간 설정 (기본 10초)

3. 미리보기
   - 총 소요 시간 표시
   - 동작 목록 확인

4. 저장
```

---

#### 📱 Screen 11: 루틴 상세 (Routine Detail Screen)
**경로**: `/routines/:id`
**파일**: `lib/presentation/screens/routine/routine_detail_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 루틴 상세 정보 확인 및 시작 |
| 구성요소 | 루틴 정보, 포함된 동작 목록, 시작 버튼 |

---

#### 📱 Screen 12: 루틴 플레이어 (Routine Player Screen)
**경로**: `/routines/:id/play`
**파일**: `lib/presentation/screens/routine/routine_player_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 루틴 실행 (연속 동작 재생) |
| 구성요소 | 영상 플레이어, 진행 상태, 타이머, 다음/이전 버튼 |

```dart
// 기능
- 동작 자동 연속 재생
- 동작 간 휴식 타이머 (카운트다운)
- 일시정지/재개
- 이전/다음 동작 스킵
- 현재 진행 상황 표시 (예: 3/7)
- 완료 시 기록 저장 및 축하 화면
```

---

#### 📱 Screen 13: 커뮤니티 (Community Screen)
**경로**: `/community` (메인 탭 인덱스 3)
**파일**: `lib/presentation/screens/community/community_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 사용자 간 경험 공유, 동기부여 |
| 구성요소 | 게시글 피드, 카테고리 탭, 글쓰기 버튼 |

```dart
// 카테고리 탭
- 전체
- 인증 (운동 인증샷)
- 질문
- 팁 공유
- 자유

// 게시글 카드 (PostCard)
- 작성자 프로필 (아바타, 닉네임)
- 게시글 내용 (텍스트)
- 이미지/영상 (선택)
- 좋아요 수, 댓글 수
- 작성 시간

// FloatingActionButton
- 새 글 작성
```

---

#### 📱 Screen 14: 게시글 상세 (Post Detail Screen)
**경로**: `/community/posts/:id`
**파일**: `lib/presentation/screens/community/post_detail_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 게시글 상세 보기 및 댓글 |
| 구성요소 | 게시글 전체 내용, 댓글 목록, 댓글 입력 |

```dart
// 구성
1. 게시글 헤더
   - 작성자 정보 (탭 → 프로필)
   - 더보기 메뉴 (신고, 차단, 수정, 삭제)

2. 게시글 본문
   - 텍스트 내용
   - 이미지 갤러리 (있는 경우)
   - 영상 (있는 경우)

3. 액션 버튼
   - 좋아요
   - 댓글
   - 공유
   - 북마크

4. 댓글 섹션
   - 댓글 목록 (CommentItem)
   - 대댓글 지원
   - 댓글 입력창 (하단 고정)
```

---

#### 📱 Screen 15: 게시글 작성 (Post Create Screen)
**경로**: `/community/posts/create`
**파일**: `lib/presentation/screens/community/post_create_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 새 게시글 작성 |
| 구성요소 | 카테고리 선택, 내용 입력, 이미지/영상 첨부 |

```dart
// 입력 필드
- 카테고리 선택 (DropdownButton)
- 제목 (선택)
- 내용 (TextField, multiline)
- 이미지 첨부 (최대 5장)
- 영상 첨부 (최대 1개, 30초 이내)

// 버튼
- 게시 버튼
- 임시저장 (선택)
```

---

#### 📱 Screen 16: 사용자 프로필 (User Profile Screen)
**경로**: `/users/:id`
**파일**: `lib/presentation/screens/community/user_profile_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 다른 사용자 프로필 보기 |
| 구성요소 | 프로필 정보, 작성 게시글 목록, 팔로우 버튼 |

---

#### 📱 Screen 17: 기록 (Record Screen)
**경로**: `/records` (메인 탭 인덱스 4 또는 프로필 내)
**파일**: `lib/presentation/screens/record/record_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 운동 기록 확인 |
| 구성요소 | 캘린더 뷰, 일별 기록, 통계 요약 |

```dart
// 구성
1. 월간 캘린더
   - 운동한 날 마킹 (색상/아이콘)
   - 날짜 탭 → 해당 일 기록 표시

2. 일별 기록
   - 완료한 루틴/동작 목록
   - 총 운동 시간

3. 통계 요약 (상단)
   - 이번 주 운동 횟수
   - 연속 운동 일수 (스트릭)
   - 총 운동 시간
```

---

#### 📱 Screen 18: 통계 (Statistics Screen)
**경로**: `/statistics`
**파일**: `lib/presentation/screens/record/statistics_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 상세 운동 통계 |
| 구성요소 | 주간/월간 차트, 부위별 통계, 성취 뱃지 |

```dart
// 차트
- 주간 운동 시간 (막대 그래프)
- 월간 운동 빈도 (라인 차트)
- 부위별 운동 비율 (파이 차트)

// 성취
- 달성 뱃지 목록
- 연속 기록 표시
```

---

#### 📱 Screen 19: 내 프로필 (Profile Screen)
**경로**: `/profile` (메인 탭 인덱스 4)
**파일**: `lib/presentation/screens/profile/profile_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 내 정보 관리 |
| 구성요소 | 프로필 정보, 내 활동, 설정 메뉴 |

```dart
// 구성
1. 프로필 헤더
   - 프로필 이미지
   - 닉네임
   - 한 줄 소개
   - 프로필 수정 버튼

2. 내 활동 요약
   - 운동 기록 바로가기
   - 내 게시글
   - 좋아요한 동작
   - 북마크

3. 메뉴 리스트
   - 알림 설정
   - 앱 설정
   - 공지사항
   - 자주 묻는 질문
   - 문의하기
   - 이용약관
   - 개인정보처리방침
   - 로그아웃
   - 회원탈퇴
```

---

#### 📱 Screen 20: 프로필 수정 (Edit Profile Screen)
**경로**: `/profile/edit`
**파일**: `lib/presentation/screens/profile/edit_profile_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 프로필 정보 수정 |
| 구성요소 | 이미지 변경, 닉네임, 소개, 비밀번호 변경 |

---

#### 📱 Screen 21: 설정 (Settings Screen)
**경로**: `/settings`
**파일**: `lib/presentation/screens/profile/settings_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 앱 설정 |
| 구성요소 | 알림, 다크모드, 언어, 캐시 삭제 등 |

```dart
// 설정 항목
- 푸시 알림 ON/OFF
- 루틴 리마인더 시간 설정
- 다크 모드
- 언어 설정
- 영상 자동재생 (Wi-Fi에서만)
- 캐시 삭제
- 앱 버전 정보
```

---

#### 📱 Screen 22: 알림 (Notification Screen)
**경로**: `/notifications`
**파일**: `lib/presentation/screens/notification/notification_screen.dart`

| 항목 | 내용 |
|------|------|
| 목적 | 알림 목록 확인 |
| 구성요소 | 알림 리스트 (좋아요, 댓글, 시스템 알림) |

---

## 6. 데이터 모델

### 6.1 User (사용자)
```dart
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
}
```

### 6.2 Motion (동작)
```dart
class MotionModel {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String thumbnailUrl;
  final int durationSeconds;
  final String difficulty; // 'beginner', 'intermediate', 'advanced'
  final List<String> bodyParts; // ['neck', 'shoulder', 'back', ...]
  final List<String> purposes; // ['stretching', 'posture', 'pain_relief', ...]
  final List<String> steps; // 단계별 설명
  final List<String> cautions; // 주의사항
  final int likeCount;
  final int viewCount;
  final DateTime createdAt;
}
```

### 6.3 Category (카테고리)
```dart
class CategoryModel {
  final String id;
  final String name;
  final String type; // 'bodyPart', 'purpose', 'difficulty', 'duration'
  final String? iconUrl;
  final int order;
}
```

### 6.4 Routine (루틴)
```dart
class RoutineModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final List<RoutineMotion> motions;
  final int totalDurationSeconds;
  final bool isPublic;
  final bool isOfficial; // 앱 제공 루틴 여부
  final DateTime createdAt;
  final DateTime? updatedAt;
}

class RoutineMotion {
  final String motionId;
  final int order;
  final int restSeconds; // 다음 동작까지 휴식 시간
}
```

### 6.5 Record (기록)
```dart
class RecordModel {
  final String id;
  final String userId;
  final String? routineId;
  final String? motionId;
  final DateTime startedAt;
  final DateTime completedAt;
  final int durationSeconds;
  final bool isCompleted;
}
```

### 6.6 Post (게시글)
```dart
class PostModel {
  final String id;
  final String userId;
  final UserModel user; // 작성자 정보
  final String category; // 'certification', 'question', 'tip', 'free'
  final String? title;
  final String content;
  final List<String> imageUrls;
  final String? videoUrl;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final DateTime? updatedAt;
}
```

### 6.7 Comment (댓글)
```dart
class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final UserModel user;
  final String content;
  final String? parentCommentId; // 대댓글인 경우
  final int likeCount;
  final DateTime createdAt;
}
```

### 6.8 Notification (알림)
```dart
class NotificationModel {
  final String id;
  final String userId;
  final String type; // 'like', 'comment', 'follow', 'system', 'reminder'
  final String title;
  final String body;
  final Map<String, dynamic>? data; // 추가 데이터 (postId, userId 등)
  final bool isRead;
  final DateTime createdAt;
}
```

---

## 7. API 엔드포인트 (REST API 사용 시)

### 7.1 인증 (Auth)
```
POST   /api/auth/register        - 회원가입
POST   /api/auth/login           - 로그인
POST   /api/auth/logout          - 로그아웃
POST   /api/auth/refresh         - 토큰 갱신
POST   /api/auth/forgot-password - 비밀번호 재설정 요청
POST   /api/auth/reset-password  - 비밀번호 재설정
```

### 7.2 사용자 (Users)
```
GET    /api/users/me             - 내 정보 조회
PUT    /api/users/me             - 내 정보 수정
GET    /api/users/:id            - 사용자 정보 조회
POST   /api/users/:id/follow     - 팔로우
DELETE /api/users/:id/follow     - 언팔로우
```

### 7.3 동작 (Motions)
```
GET    /api/motions              - 동작 목록 (필터, 페이지네이션)
GET    /api/motions/:id          - 동작 상세
GET    /api/motions/recommended  - 추천 동작
POST   /api/motions/:id/like     - 좋아요
DELETE /api/motions/:id/like     - 좋아요 취소
POST   /api/motions/:id/view     - 조회수 증가
```

### 7.4 루틴 (Routines)
```
GET    /api/routines             - 내 루틴 목록
GET    /api/routines/official    - 공식 루틴 목록
POST   /api/routines             - 루틴 생성
GET    /api/routines/:id         - 루틴 상세
PUT    /api/routines/:id         - 루틴 수정
DELETE /api/routines/:id         - 루틴 삭제
```

### 7.5 기록 (Records)
```
GET    /api/records              - 기록 목록 (기간별)
POST   /api/records              - 기록 저장
GET    /api/records/statistics   - 통계 조회
GET    /api/records/streak       - 연속 기록 조회
```

### 7.6 커뮤니티 (Community)
```
GET    /api/posts                - 게시글 목록 (카테고리, 페이지네이션)
POST   /api/posts                - 게시글 작성
GET    /api/posts/:id            - 게시글 상세
PUT    /api/posts/:id            - 게시글 수정
DELETE /api/posts/:id            - 게시글 삭제
POST   /api/posts/:id/like       - 좋아요
DELETE /api/posts/:id/like       - 좋아요 취소

GET    /api/posts/:id/comments   - 댓글 목록
POST   /api/posts/:id/comments   - 댓글 작성
PUT    /api/comments/:id         - 댓글 수정
DELETE /api/comments/:id         - 댓글 삭제
```

### 7.7 알림 (Notifications)
```
GET    /api/notifications        - 알림 목록
PUT    /api/notifications/:id/read - 읽음 처리
PUT    /api/notifications/read-all - 전체 읽음
```

---

## 8. 주요 기능 상세

### 8.1 영상 플레이어 기능
- 재생/일시정지
- 구간 반복 (특정 구간 설정하여 반복)
- 재생 속도 조절 (0.5x, 0.75x, 1x, 1.25x, 1.5x)
- 전체 화면 모드
- 자동 화면 꺼짐 방지
- 가로/세로 모드 지원
- 백그라운드 재생 방지

### 8.2 알림/리마인더 기능
- 루틴 시작 알림 (지정 시간)
- 커뮤니티 알림 (좋아요, 댓글)
- 동기부여 알림 ("오늘도 스트레칭 어떠세요?")
- 알림 설정 커스터마이징

### 8.3 오프라인 지원 (선택)
- 좋아요한 동작 영상 다운로드
- 오프라인 시 로컬 기록 저장 → 온라인 시 동기화

---

## 9. UI/UX 가이드라인

### 9.1 색상 팔레트 (제안)
```dart
// Primary Colors
static const Color primary = Color(0xFF4CAF50);      // 건강한 그린
static const Color primaryLight = Color(0xFF81C784);
static const Color primaryDark = Color(0xFF388E3C);

// Secondary Colors
static const Color secondary = Color(0xFF03A9F4);    // 활동적인 블루
static const Color secondaryLight = Color(0xFF4FC3F7);
static const Color secondaryDark = Color(0xFF0288D1);

// Neutral Colors
static const Color background = Color(0xFFF5F5F5);
static const Color surface = Color(0xFFFFFFFF);
static const Color textPrimary = Color(0xFF212121);
static const Color textSecondary = Color(0xFF757575);

// Status Colors
static const Color success = Color(0xFF4CAF50);
static const Color error = Color(0xFFF44336);
static const Color warning = Color(0xFFFFC107);
```

### 9.2 타이포그래피
```dart
// Headings
headline1: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)
headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
headline3: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)

// Body
bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)
bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)
bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal)

// Labels
labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
```

### 9.3 간격/여백
```dart
static const double xs = 4.0;
static const double sm = 8.0;
static const double md = 16.0;
static const double lg = 24.0;
static const double xl = 32.0;
```

---

## 10. 향후 확장 계획 (v2.0+)

### 10.1 AI 자세 분석 기능
- 카메라로 사용자 동작 촬영
- AI가 자세 분석 및 피드백 제공
- 올바른 자세와 비교 화면

### 10.2 소셜 기능 강화
- 팔로우/팔로워 시스템
- 친구와 함께 루틴 도전
- 그룹 챌린지

### 10.3 프리미엄 기능
- 전문가 1:1 코칭
- 프리미엄 콘텐츠
- 광고 제거

### 10.4 웨어러블 연동
- Apple Watch / Galaxy Watch 연동
- 심박수 기반 운동 강도 조절

---

## 11. 개발 우선순위 (MVP)

### Phase 1 - 핵심 기능 (4-6주)
1. ✅ 인증 (로그인/회원가입)
2. ✅ 동작 라이브러리 (목록/상세/영상플레이어)
3. ✅ 기본 루틴 기능 (목록/생성/실행)
4. ✅ 기록 저장

### Phase 2 - 커뮤니티 (3-4주)
1. ✅ 게시글 CRUD
2. ✅ 댓글 기능
3. ✅ 좋아요 기능
4. ✅ 사용자 프로필

### Phase 3 - 고도화 (2-3주)
1. ✅ 푸시 알림
2. ✅ 통계/차트
3. ✅ 설정
4. ✅ 성능 최적화

---

## 부록: 화면 와이어프레임 참고

각 화면의 대략적인 레이아웃은 아래와 같이 구성됩니다:

```
┌─────────────────────────────┐
│         AppBar              │
├─────────────────────────────┤
│                             │
│                             │
│         Content             │
│                             │
│                             │
├─────────────────────────────┤
│     BottomNavigationBar     │
│  [홈] [동작] [루틴] [커뮤] [MY] │
└─────────────────────────────┘
```

---

**문서 버전**: 1.0
**작성일**: 2025년
**작성자**: Claude AI Assistant
