import '../../features/home/data/roles_model.dart';
import '../api_base.dart';
import 'package:dartz/dartz.dart';
import '../api_config.dart';
class UserAccessProfileApi extends ApiBase<List<Role>> {
  Future<Either<String, List<Role>>> fetchRoles() async {
    Role getResourceFromJson(Map<String, dynamic> json) {
      return Role.fromJson(json);
    }
    return makeGetRequest(dioClient.dio.get(ApiConfig.myRoles,), getResourceFromJson);
  }
}
