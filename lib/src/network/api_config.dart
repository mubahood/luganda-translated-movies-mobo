import "package:shared_preferences/shared_preferences.dart";

class ApiConfig {
  ApiConfig._();

  static const String baseUrl = "https://unified.m-omulimisa.com/api/v1";
  static const Duration receiveTimeout = Duration(milliseconds: 15000);
  static const Duration connectionTimeout = Duration(milliseconds: 15000);
  static const String register = "/register";
  static const String login = "/login";
  static const String profile = "/me";
  static const String resources = "/resources";
  static const String myRoles = '/my-roles';
  static const String update = '/update-profile';
  static const String trainings = '/trainings';

  static Future<Map<String, String>> get header async{
    final  token =  await getToken();
    return {
    'Authorization': 'Bearer $token',
    'content-Type': 'application/json',
  };
  }

  static Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    return token ?? '';
  }

}

