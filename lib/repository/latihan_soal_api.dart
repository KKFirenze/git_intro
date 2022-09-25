import 'dart:io';

import 'package:dio/dio.dart';
import 'package:git_project/constants/api_url.dart';
import 'package:git_project/helpers/user_helpers.dart';
import 'package:git_project/models/network_response/network_responses.dart';

class LatihanSoalAPI {
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

  Future<NetworkResponses> getMapel() async {
    final result =
        await _getRequest(endPoint: ApiLatihanSoal.latihanMapel, params: {
      'major_name': 'IPA',
      'user_email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  Future<NetworkResponses> getPaketSoal(id) async {
    final result =
        await _getRequest(endPoint: ApiLatihanSoal.latihanPaketSoal, params: {
      'course_id': id,
      'user_email': UserHelpers.getUserEmail(),
    });
    return result;
  }

  Future<NetworkResponses> getBanner() async {
    final result = await _getRequest(
      endPoint: ApiBanner.banner,
      // params: {
      //   'major_name': 'IPA',
      // },
    );
    return result;
  }

  Future<NetworkResponses> postKerjakanSoal(id) async {
    final result = await _postRequest(
      endPoint: ApiLatihanSoal.latihanKerjakanSoal,
      body: {
        'exercise_id': id,
        'user_email': UserHelpers.getUserEmail(),
      },
    );

    return result;
  }

  Future<NetworkResponses> postInputJawaban(payload) async {
    final result = await _postRequest(
      endPoint: ApiLatihanSoal.latihanSubmitJawaban,
      body: payload,
    );

    return result;
  }

  Future<NetworkResponses> getScoreResult(id) async {
    final result = await _getRequest(
      endPoint: ApiLatihanSoal.latihanSkor,
      params: {
        'exercise_id': id,
        'user_email': UserHelpers.getUserEmail(),
      },
    );
    return result;
  }
}
