import 'package:flutter/material.dart';

class AppTheme {
  static const _primarySkyBlue = Color(0xFF87CEEB); // 파스텔 하늘색
  static const _secondarySkyBlue = Color(0xFFB0E0E6); // 더 연한 파스텔 하늘색
  static const _backgroundSkyBlue = Color(0xFFE6F3FF); // 배경용 하늘색

  // Light Theme
  static final lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _backgroundSkyBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primarySkyBlue,
      brightness: Brightness.light,
      primary: _primarySkyBlue,
      secondary: _secondarySkyBlue,
      // 파스텔톤 색상 커스터마이징
      surface: _backgroundSkyBlue,
      background: _backgroundSkyBlue,
      error: const Color(0xFFFF9B9B), // 부드러운 에러 색상
    ).copyWith(
      primaryContainer: const Color(0xFFE1F1FF),
      secondaryContainer: const Color(0xFFF0F8FF),
    ),
    // 카드 스타일
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white,
    ),
    // 아이콘 테마
    iconTheme: const IconThemeData(
      color: _primarySkyBlue,
      size: 24,
    ),
    // 앱바 테마
    appBarTheme: const AppBarTheme(
      backgroundColor: _backgroundSkyBlue,
      foregroundColor: _primarySkyBlue,
      elevation: 0,
      scrolledUnderElevation: 0, // 스크롤 시 엘레베이션 효과 제거
      surfaceTintColor: Colors.transparent, // 서피스 틴트 효과 제거
      centerTitle: true,
    ),
    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primarySkyBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    // 슬라이더 테마
    sliderTheme: SliderThemeData(
      activeTrackColor: _primarySkyBlue,
      inactiveTrackColor: _primarySkyBlue.withOpacity(0.2),
      thumbColor: _primarySkyBlue,
      overlayColor: _primarySkyBlue.withOpacity(0.1),
    ),
    // 내비게이션바 테마
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: _primarySkyBlue.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    ),
    // 기본 폰트 패밀리 설정
    fontFamily: 'Dongle',
    // 텍스트 테마
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 42,
        fontWeight: FontWeight.bold,
        fontFamily: 'Dongle',
      ),
      headlineMedium: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 36,
        fontWeight: FontWeight.bold,
        fontFamily: 'Dongle',
      ),
      titleLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 32,
        fontWeight: FontWeight.w600,
        fontFamily: 'Dongle',
        height: 1.2,
      ),
      titleMedium: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 28,
        fontWeight: FontWeight.w500,
        fontFamily: 'Dongle',
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 16, // 본문은 NanumGothic으로 변경하여 가독성 향상
        fontFamily: 'NanumGothic',
        height: 1.6, // NanumGothic에 맞는 행간
      ),
      bodyMedium: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 14, // 본문은 NanumGothic으로 변경
        fontFamily: 'NanumGothic',
        height: 1.6,
      ),
      labelLarge: TextStyle(
        color: Color(0xFF2C3E50),
        fontSize: 14, // 레이블도 NanumGothic 적용
        fontWeight: FontWeight.w500,
        fontFamily: 'NanumGothic',
        height: 1.4,
      ),
      bodySmall: TextStyle(
        // 작은 텍스트를 위한 스타일 추가
        color: Color(0xFF2C3E50),
        fontSize: 12,
        fontFamily: 'NanumGothic',
        height: 1.4,
      ),
    ),
  );
}
