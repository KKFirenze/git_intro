import 'dart:io';

import 'package:dio/dio.dart';
import 'package:git_project/constants/api_url.dart';
import 'package:git_project/helpers/user_helpers.dart';
import 'package:git_project/models/network_response/network_responses.dart';

class AuthAPI {
  Dio _dioAPI() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrl.baseURL,
      headers: {
        "x-api-key": ApiUrl.apiKEY,
        HttpHeaders.contentTypeHeader: "application/json",
      },
      responseType: ResponseType.json,
    );

    final dio = Dio(options);
    return dio;
  }

  Future<NetworkResponses> _getRequest({endPoint, params}) async {
    try {
      final dio = _dioAPI();
      final result = await dio.get(endPoint, queryParameters: params);
      return NetworkResponses.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponses.error(data: null, message: 'Request Timeout');
      }
      return NetworkResponses.error(data: null, message: 'Error Dio');
    } catch (e) {
      return NetworkResponses.error(data: null, message: 'Other Error');
    }
  }

  Future<NetworkResponses> _postRequest({endPoint, body}) async {
    try {
      final dio = _dioAPI();
      final result = await dio.post(endPoint, data: body);
      return NetworkResponses.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponses.error(data: null, message: 'Request Timeout');
      }
      return NetworkResponses.error(data: null, message: 'Error Dio');
    } catch (e) {
      return NetworkResponses.error(data: null, message: 'Other Error');
    }
  }

  Future<NetworkResponses> getUserByEmail() async {
    final result = await _getRequest(endPoint: ApiUserUrl.users, params: {
      'email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  Future<NetworkResponses> postRegister(json) async {
    final result = await _postRequest(
      endPoint: ApiUserUrl.userRegistration,
      body: json,
    );

    return result;
  }

  Future<NetworkResponses> postUpdateUser(json) async {
    final result = await _postRequest(
      endPoint: ApiUserUrl.userUpdateProfile,
      body: json,
    );

    return result;
  }
}
