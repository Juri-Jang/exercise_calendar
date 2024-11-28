import 'package:exercise_calendar/util/constants.dart';
import 'package:get/get.dart';

class UserProvider extends GetConnect {
  // 로그인 요청
  Future<Response> login(Map<String, dynamic> data) {
    return post(
      "$BASE_URL/login",
      data,
      headers: {'Content-Type': 'application/json'},
    );
  }

  // 회원가입 요청
  Future<Response> register(Map<String, dynamic> data) {
    return post(
      "$BASE_URL/user/register",
      data,
      headers: {'Content-Type': 'application/json'},
    );
  }

  // ID 중복 확인
  Future<bool> isUseridTaken(String username) async {
    final response = await get("$BASE_URL/user/check-userid/$username");
    if (response.statusCode == 200) {
      return response.body as bool;
    }
    throw Exception('ID 중복 확인 실패');
  }

  // 사용자 정보 조회
  Future<Response> getUserInfo(String token) {
    return get(
      "$BASE_URL/user/profile",
      headers: {'Authorization': '$token'},
    );
  }
}
