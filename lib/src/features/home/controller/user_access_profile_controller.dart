import 'package:get/get.dart';
import '../../../network/user_access_profile_Api/user_access_profile_Api.dart';
import '../data/roles_model.dart';

class UserAccessController extends GetxController {
  final UserAccessProfileApi _api = UserAccessProfileApi();

   List<Role> roles = <Role>[].obs;

  Future<void> fetchRoles() async {

    final result = await _api.fetchRoles();

    result.fold(
          (String failure) {
            if(failure=='Invalid response data'){
              return;
            }else{
              Get.snackbar('Error', failure);
            }

      },
          (List<Role> data) {
        roles= data;
      },
    );
  }
}


