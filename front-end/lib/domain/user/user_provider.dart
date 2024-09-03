import 'package:get/get.dart';

const host = "http://192.168.219.103:8080";

//통신
//GetConnet => GetX에서 제공하는 http 통신 라이브러리
class UserProvider extends GetConnect {
  Future<Response> register(Map data) {
    return post(
      "$host/register",
      data,
      headers: {'Content-Type': 'application/json'},
    );
  }
}
