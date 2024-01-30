import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'api_config.dart';
import 'dio_interceptor.dart';

class DioClient extends GetxService {
  late final Dio dio;

  @override
  void onInit() async {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectionTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        responseType: ResponseType.json,
        headers: await ApiConfig.header
      ),
    )..interceptors.add(DioInterceptor());


    super.onInit();
  }
}
