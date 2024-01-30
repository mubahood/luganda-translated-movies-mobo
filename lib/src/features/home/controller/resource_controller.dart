import 'package:get/get.dart';

import '../../../network/resource_Api/resource_api.dart';
import '../data/resource_model.dart';
enum ResourceState {
  loading,
  loaded,
  error,
}
class ResourceController extends GetxController {
  final ResourceApi _api = ResourceApi();

  RxList<Resource> resources = RxList<Resource>([]);
  final Rx<ResourceState> state = ResourceState.loading.obs;

  Future<void> fetchResources() async {
    state.value = ResourceState.loading;
    final result = await _api.fetchResources();

    result.fold(
          (String failure) {
            state.value = ResourceState.error;
        Get.snackbar('Error', failure);
      },
          (List<Resource> data) {
        resources.value = data;
        state.value = ResourceState.loaded;
      },
    );
  }
}


