import 'dart:ui';

class AppConfig {
  static const String BASE_URL = "http://10.0.2.2/katogo";

  // static const String BASE_URL = "https://katogo.schooldynamics.ug";
  static const String MAIN_SITE_URL = BASE_URL;
  static String API_BASE_URL = "${BASE_URL}/api";
  static const String DASHBOARD_URL = "https://katogo.schooldynamics.ug";
  static const String ONESIGNAL_APP_ID = "3f223c2e-7191-4f2d-a1c1-bd7ae47625ce";
  static const String APP_NAME = "moviebox";
  static const int APP_VERSION = 10;
  static const String DATABASE_PATH = "movies_${12}";
  static const String STORAGE_URL = "$BASE_URL/storage/";
  static const String logo_1 = "assets/images/logo.png";
  static const String logo_2 = "assets/images/logo.png";
  static const String logo_3 = "assets/images/logo.png";
  static const String USER_IMAGE = "assets/images/logo_3.png";
  static const String NO_IMAGE = "assets/images/no_image.png";
  static const String AUDIO_PHOTO = "assets/images/wap.png";
  static const String GOOGLE_MAP_API =
      "AIzaSyBbXYigCGL7Du8zAiJ9ZWP1a0mw1zOJevw";

  //list of nice background solid colors
  static const List<String> VJs = [
    'Junior',
    'Jingo',
    'Muba',
    'Kevo',
    'Baros',
    'Ulio',
    'Emmy',
    'Ice p',
    'Ivo',
    'Shao Khani Lee',
    'Unknown'
  ];
  static const List<Color> nice_colors = [
    Color(0xFFE57373),
    Color(0xFFF06292),
    Color(0xFFBA68C8),
    Color(0xFF9575CD),
    Color(0xFF7986CB),
    Color(0xFF64B5F6),
    Color(0xFF4FC3F7),
    Color(0xFF4DD0E1),
    Color(0xFF4DB6AC),
    Color(0xFF81C784),
    Color(0xFFAED581),
    Color(0xFFFF8A65),
    Color(0xFFD4E157),
    Color(0xFFFFD54F),
    Color(0xFFFFB74D),
    Color(0xFFA1887F),
    Color(0xFF90A4AE),
  ];
}
