import 'package:get/get.dart';

const host = "http://192.168.219.103:8080";

//통신
class UserProvider extends GetConnect {
  Future<Response> register(Map data) => post("$host/register", data);
}
