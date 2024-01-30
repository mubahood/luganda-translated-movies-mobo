import 'package:get/get.dart';
import '../../../network/training_Api/training_api.dart';
import '../data/training.dart';
enum TrainingState {
  loading,
  loaded,
  error,
}
class TrainingController extends GetxController {
  final TrainingApi _api = TrainingApi();

  RxList<TrainingSession> trainingList = RxList<TrainingSession>([]);
  final Rx<TrainingState> state = TrainingState.loading.obs;

  Future<void> fetchTrainingList() async {
    state.value = TrainingState.loading;
    final result = await _api.fetchTrainingsList();

    result.fold(
          (String failure) {
        state.value = TrainingState.error;
        Get.snackbar('Error', failure);
      },
          (List<TrainingSession> data) {
        trainingList.value = data;
        state.value = TrainingState.loaded;
      },
    );
  }
}


