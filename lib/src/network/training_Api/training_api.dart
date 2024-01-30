
import '../../features/home/data/training.dart';
import '../api_base.dart';
import 'package:dartz/dartz.dart';
import '../api_config.dart';
class TrainingApi extends ApiBase<List<TrainingSession>> {
  Future<Either<String, List<TrainingSession>>> fetchTrainingsList() async {
    TrainingSession getResourceFromJson(Map<String, dynamic> json) {
      return TrainingSession.fromJson(json);
    }
    return makeGetRequest(dioClient.dio.get(ApiConfig.trainings,), getResourceFromJson);
  }
}
