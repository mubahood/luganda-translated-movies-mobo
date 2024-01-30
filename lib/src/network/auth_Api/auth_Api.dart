
import 'package:dartz/dartz.dart';

import '../../features/authentication/models/user_model.dart';
import '../api_base.dart';
import '../api_config.dart';
class AuthApi extends ApiBase<UserModel> {
  Future<Either<String, bool>> registerUser({
    required String fullName,
    String? email,
    required String phoneNumber,
    required String password,
  }) async {
    final createUserFormData = {
      'name': fullName,
      'email': email ?? "",
      'phone': phoneNumber,
      'password': password,
    };


    return await makePostRequest(dioClient.dio.post(ApiConfig.register, data: createUserFormData));
  }

  Future<Either<String, UserModel>> loginUser({
    required String emailOrPhoneNumber,
    required String password,
  }) async {
    final credentials = {
      'username': emailOrPhoneNumber,
      'password': password,
    };
    UserModel getUserModelFromJson(Map<String, dynamic> json) {
      return UserModel.fromJson(json);
    }

    return await makePostRequestWithReturnData(dioClient.dio.post(ApiConfig.login, data: credentials), getUserModelFromJson);
  }

  Future<Either<String, UserModel>> updateUser({
     String? email,
     String? password,
     String? phone,
     String?  photo,
    String? name
  }) async {
    final userProfileData = {
      'name': name,
      'password': password,
      'phone':phone,
      'photo':photo,
      'email':email
    };
    UserModel getUserModelFromJson(Map<String, dynamic> json) {
      return UserModel.fromJson(json);
    }

    return await makePostRequestWithReturnDataNoToken(dioClient.dio.post(ApiConfig.update, data: userProfileData), getUserModelFromJson);
  }

}
