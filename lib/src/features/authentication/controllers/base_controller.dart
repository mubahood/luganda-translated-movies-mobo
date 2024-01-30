
import "package:get/get.dart";
import '../../../../models/RespondModel.dart';
import '../../../../utils/Utilities.dart';
import '../../../network/auth_Api/auth_Api.dart';
import '../../../routing/routing.dart';
import '../models/user_model.dart';
import '../models/user_update_form_data.dart';
// enum AuthState { idle, loading, success, failure }

class AuthController {
  final AuthApi _authApi = AuthApi();
  final  isLoading = false.obs;

  Future<void> registerUser({
    required String fullName,
    String? email,
    required String phoneNumber,
    required String password,
  }) async {

  isLoading.value = true;
  final createUserFormData = {
    'name': fullName,
    'email': email ?? "",
    'phone': phoneNumber,
    'password': password,
  };

  RespondModel resp =
  RespondModel(await Utils.http_post('register', createUserFormData));

  if (resp.code != 1) {
    Utils.toast(resp.message);
    return;
  }

  UserModel u = UserModel.fromJson(resp.data);

  /*if (!(await u.save())) {
    Utils.toast("failed to save user");
    return;
  }else{
    Utils.toast("Successfully  created Account !");
    Get.off(() => HomeScreen());
  }*/

  }

  Future<void> loginUser({
    required String emailOrPhoneNumber,
    required String password,
  }) async {

    isLoading.value = true;
    final credentials = {
      'username': emailOrPhoneNumber,
      'password': password,
    };
    final result = await _authApi.loginUser(
      emailOrPhoneNumber: emailOrPhoneNumber,
      password: password,
    );

    result.fold(
          (String failure) {
            isLoading.value = false;
            Get.snackbar('Login Failed', failure);
      },
          (UserModel user) {
            isLoading.value =false ;
            Get.snackbar('Login', 'successfully Logged in');
            Get.toNamed(AppRouter.home, arguments: {'userModel':user});
        // Handle successful login, if needed
      },
    );
  }

  Future<void> updateUserProfile({
    required UserProfile userProfile,
  }) async {

    isLoading.value = true;
    final result = await _authApi.updateUser(
      email: userProfile.email,
      password: userProfile.password,
      photo: userProfile.photo,
      name: userProfile.name
    );

    result.fold(
          (String failure) {
        isLoading.value = false;
        Get.snackbar('update of profile unsuccessful', failure);
      },
          (UserModel user) async{
        isLoading.value =false ;
        Get.snackbar('success', 'successfully update profile');
        Get.toNamed(AppRouter.home, arguments: {'userModel':user});
        // Handle successful login, if needed
      },
    );
  }


}
