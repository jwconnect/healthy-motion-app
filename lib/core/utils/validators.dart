class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return '올바른 이메일 형식이 아닙니다';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요';
    }
    if (value.length < 8) {
      return '비밀번호는 8자 이상이어야 합니다';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요';
    }
    if (value != password) {
      return '비밀번호가 일치하지 않습니다';
    }
    return null;
  }

  static String? nickname(String? value) {
    if (value == null || value.isEmpty) {
      return '닉네임을 입력해주세요';
    }
    if (value.length < 2) {
      return '닉네임은 2자 이상이어야 합니다';
    }
    if (value.length > 20) {
      return '닉네임은 20자 이하여야 합니다';
    }
    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName을(를) 입력해주세요' : '필수 입력 항목입니다';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName은(는) $minLength자 이상이어야 합니다'
          : '$minLength자 이상 입력해주세요';
    }
    return null;
  }

  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length > maxLength) {
      return fieldName != null
          ? '$fieldName은(는) $maxLength자 이하여야 합니다'
          : '$maxLength자 이하로 입력해주세요';
    }
    return null;
  }
}
