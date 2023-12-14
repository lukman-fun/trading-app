import 'dart:convert';

import 'package:http_interceptor/http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:trading/utils/sessions.dart';

class LoginIntercept implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    // TODO: implement interceptRequest
    print('==============REQUEST==============');
    print(data);
    // throw UnimplementedError();
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    // TODO: implement interceptResponse
    print('==============RESPONSE==============');
    print(data);
    return data;
    // throw UnimplementedError();
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if (response.statusCode == 403 &&
        jsonDecode(response.body!)['message'] == 'Token is Expired') {
      var responses = await http.post(
        Uri.parse('http://192.168.18.14:8000/api/auth/refresh'),
        headers: {"Authorization": "Bearer ${await Sessions.jwtToken()}"},
      );

      if (responses.statusCode == 200) {
        Sessions.save(response.body);
        print("SAVE SESSION REFRESH");
        print(response.body);

        return true;
      }

      return false;
    }

    return false;
  }
}
