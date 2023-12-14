import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';
import 'package:trading/utils/login_intercept.dart';

class ClientHTTP {
  Client getClitentHTTP() {
    Client client = InterceptedClient.build(interceptors: [
      LoginIntercept(),
    ]);
    return client;
  }
}
