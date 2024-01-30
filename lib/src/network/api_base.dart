
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import "package:get/get.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'dio_client.dart';
import 'dio_exceptions.dart';


abstract class ApiBase<T> {
  final DioClient dioClient = Get.put(DioClient());
  Future<Either<String, T>> _checkFailureOrSuccessRequestWithReturnData(Future<dio.Response<dynamic>> apiCallback,T Function(Map<String, dynamic> json) getFromJsonCallback ) async {
    try {
      final response = await apiCallback;
      final responseData = response.data;
      final code = responseData['code'];
      final message = responseData['message'];



      if ( code is int && code != 0) {
        final token = responseData['data']['token'] as String ;
        final data = getFromJsonCallback(responseData['data']);
        await storeToken(token);
        return right(data );
      } else {
        return left(message ?? 'Unknown error occurred');
      }
    } on dio.DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return left(errorMessage);
    }
  }
  Future<Either<String, T>> _checkFailureOrSuccessP(Future<dio.Response<dynamic>> apiCallback,T Function(Map<String, dynamic> json) getFromJsonCallback ) async {
    try {
      final response = await apiCallback;
      final responseData = response.data;
      final code = responseData['code'];
      final message = responseData['message'];



      if ( code is int && code != 0) {
        final data = getFromJsonCallback(responseData['data']);
        return right(data );
      } else {
        return left(message ?? 'Unknown error occurred');
      }
    } on dio.DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return left(errorMessage);
    }
  }
  Future<Either<String, bool>> _checkFailureOrSuccess(
      Future<dio.Response<dynamic>> apiCallback) async {
    try {
     final response=  await apiCallback;
     final code = response.data['code'];
     final message = response.data['message'];
      if(code!=0){
        return right(true);
      }else{
        return left(message);
      }

    } on dio.DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return left(errorMessage);
    }
  }

  Future<Either<String, bool>> makePostRequest(Future<dio.Response<dynamic>> apiCallback) async {
    return _checkFailureOrSuccess(apiCallback);
  }


  Future<Either<String, T>> makePostRequestWithReturnData(Future<dio.Response<dynamic>> apiCallback, T Function(Map<String, dynamic> json) getFromJsonCallback) async {
    return _checkFailureOrSuccessRequestWithReturnData(apiCallback, getFromJsonCallback);
  }
  Future<Either<String, T>> makePostRequestWithReturnDataNoToken(Future<dio.Response<dynamic>> apiCallback, T Function(Map<String, dynamic> json) getFromJsonCallback) async {
    return _checkFailureOrSuccessP(apiCallback, getFromJsonCallback);
  }
  Future<Either<String, List<T>>> makeGetRequest<T>(
      Future<dio.Response<dynamic>> apiCallback,
      T Function(Map<String, dynamic> json) getJsonCallback,
      ) async {
    try {
      final response = await apiCallback;
      final responseData = response.data;
      final code = responseData['code'];
      final message = responseData['message'];
      if (code is int && code != 0) {
        if (responseData['data'] is List<dynamic> && responseData['data'].isNotEmpty) {
          final List<T> dataList = List<T>.from(
            responseData['data'].map((item) => getJsonCallback(item)),
          );
          return right(dataList);
        } else {
          return left('Invalid response data');
        }
      } else {

        return left(message?? 'Unknown Error Occurred');
      }
    } on dio.DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return left(errorMessage);
    }
  }


  Future<void> storeToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }

}
