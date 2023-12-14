class BaseTrading {
  final _DEV = false;
  final _BASE_DEV = "http://192.168.18.14:8000/";
  final _BASE_PROD = "https://trading.hobstudiosolo.com/";

  final _API_DEV = "http://192.168.18.14:8000/api/";
  final _API_PROD = "https://trading.hobstudiosolo.com/api/";

  final _SOCKET_DEV = "http://192.168.18.14:8989/";
  final _SOCKET_PROD = "https://trading-wss.hobstudiosolo.com/";

  late String SOCKET;
  late String BASE;
  late String API;

  BaseTrading() {
    API = _DEV ? _API_DEV : _API_PROD;
    BASE = _DEV ? _BASE_DEV : _BASE_PROD;
    SOCKET = _DEV ? _SOCKET_DEV : _SOCKET_PROD;
  }
}
