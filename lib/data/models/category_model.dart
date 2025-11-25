class CategoryModel {
  final String id;
  final String name;
  final String type;
  final String? iconUrl;
  final int order;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    this.iconUrl,
    this.order = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      iconUrl: json['iconUrl'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'iconUrl': iconUrl,
      'order': order,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? type,
    String? iconUrl,
    int? order,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      iconUrl: iconUrl ?? this.iconUrl,
      order: order ?? this.order,
    );
  }

  // 부위별 카테고리
  static List<CategoryModel> get bodyPartCategories => [
        CategoryModel(id: 'neck', name: '목/어깨', type: 'bodyPart', order: 1),
        CategoryModel(id: 'back', name: '허리/등', type: 'bodyPart', order: 2),
        CategoryModel(id: 'lower_body', name: '하체', type: 'bodyPart', order: 3),
        CategoryModel(id: 'full_body', name: '전신', type: 'bodyPart', order: 4),
        CategoryModel(id: 'wrist_ankle', name: '손목/발목', type: 'bodyPart', order: 5),
      ];

  // 목적별 카테고리
  static List<CategoryModel> get purposeCategories => [
        CategoryModel(id: 'stretching', name: '스트레칭', type: 'purpose', order: 1),
        CategoryModel(id: 'posture', name: '자세교정', type: 'purpose', order: 2),
        CategoryModel(id: 'pain_relief', name: '통증완화', type: 'purpose', order: 3),
        CategoryModel(id: 'strength', name: '근력강화', type: 'purpose', order: 4),
        CategoryModel(id: 'relax', name: '릴렉스', type: 'purpose', order: 5),
      ];

  // 난이도 카테고리
  static List<CategoryModel> get difficultyCategories => [
        CategoryModel(id: 'beginner', name: '초급', type: 'difficulty', order: 1),
        CategoryModel(id: 'intermediate', name: '중급', type: 'difficulty', order: 2),
        CategoryModel(id: 'advanced', name: '고급', type: 'difficulty', order: 3),
      ];

  // 소요시간 카테고리
  static List<CategoryModel> get durationCategories => [
        CategoryModel(id: 'under_5', name: '5분 이내', type: 'duration', order: 1),
        CategoryModel(id: '5_to_10', name: '5~10분', type: 'duration', order: 2),
        CategoryModel(id: '10_to_20', name: '10~20분', type: 'duration', order: 3),
        CategoryModel(id: 'over_20', name: '20분 이상', type: 'duration', order: 4),
      ];

  // 커뮤니티 카테고리
  static List<CategoryModel> get communityCategories => [
        CategoryModel(id: 'all', name: '전체', type: 'community', order: 0),
        CategoryModel(id: 'certification', name: '인증', type: 'community', order: 1),
        CategoryModel(id: 'question', name: '질문', type: 'community', order: 2),
        CategoryModel(id: 'tip', name: '팁 공유', type: 'community', order: 3),
        CategoryModel(id: 'free', name: '자유', type: 'community', order: 4),
      ];
}
