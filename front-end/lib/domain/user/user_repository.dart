import 'package:exercise_calendar/dto/LoginReqDto.dart';
import 'package:exercise_calendar/dto/SignupReqDto.dart';
import 'package:exercise_calendar/domain/service/storage_service.dart';
import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();
  final StorageService _storageService = StorageService();

  //로그인
  Future<String?> login(String username, String password) async {
    try {
      // 요청 데이터 생성
      LoginReqDto loginReqDto = LoginReqDto(username, password);
      // API 호출
      Response response = await _userProvider.login(loginReqDto.toJson());

      // 응답 처리
      if (response.statusCode == 200) {
        // Authorization 헤더에서 토큰 추출
        final String? token = response.headers?["authorization"];
        if (token != null) {
          return token;
        } else {
          throw Exception('Authorization 헤더에 토큰이 없습니다.');
        }
      } else {
        print('로그인 실패: ${response.bodyString}');
        return null;
      }
    } catch (e) {
      print('로그인 요청 중 오류 발생: $e');
    }
  }

  //회원가입
  Future<void> signup(
      String name, String username, String password, String email) async {
    try {
      // 요청 데이터 생성
      SignupReqDto signupReqDto = SignupReqDto(username, password, name, email);

      // API 호출
      Response response = await _userProvider.register(signupReqDto.toJson());
      if (response.statusCode != 201) {
        throw Exception('회원가입 실패: ${response.bodyString}');
      }
      print('회원가입 성공');
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
    }
  }

  //ID 중복 확인
  Future<bool> isUseridTaken(String userid) async {
    try {
      return await _userProvider.isUseridTaken(userid);
    } catch (e) {
      print('ID 중복 확인 중 오류 발생: $e');
      return false;
    }
  }

  //마이페이지
  Future<Map<String, dynamic>> getUserInfo() async {
    final String? token = await _storageService.getToken();

    if (token == null) {
      throw Exception("로그인 정보가 없습니다.");
    }
    final response = await _userProvider.getUserInfo(token);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("사용자 정보 불러오기 실패: ${response.bodyString}");
    }
  }
}
