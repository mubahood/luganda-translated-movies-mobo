import '../../features/home/data/resource_model.dart';
import '../api_base.dart';
import 'package:dartz/dartz.dart';
import '../api_config.dart';
class ResourceApi extends ApiBase<List<Resource>> {
  Future<Either<String, List<Resource>>> fetchResources() async {
    Resource getResourceFromJson(Map<String, dynamic> json) {
      return Resource.fromJson(json);
    }
    return makeGetRequest(dioClient.dio.get(ApiConfig.resources,), getResourceFromJson);
  }
}
