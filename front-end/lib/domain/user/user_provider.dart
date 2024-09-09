import 'package:get/get.dart';

// const host = "http://192.168.219.103:8080";
const host = "http://10.73.30.146:8080";

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

  // 회원가입 id 중복 확인
  Future<bool> isUseridTaken(String userid) async {
    final response = await get(
        '$host/check-userid/$userid'); // query => URL 끝에 ?로 시작하는 부분 (키-값 깡으로 데이터를 서버에 전달)

    if (response.statusCode == 200) {
      return response.body as bool;
    } else {
      print('Error: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to check userid');
    }
  }
}
