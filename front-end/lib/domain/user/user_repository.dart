import 'package:dio/dio.dart';
import 'package:exercise_calendar/dto/LoginReqDto.dart';
import 'package:exercise_calendar/dto/SignupReqDto.dart';
import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:exercise_calendar/view/pages/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

class UserRepository {
  final UserProvider _userProvider = UserProvider();
  final _storage = new FlutterSecureStorage();

  Future<bool?> login(
      BuildContext context, String username, String password) async {
    try {
      LoginReqDto loginReqDto = LoginReqDto(username, password);
      Response response =
          await _userProvider.login(context, loginReqDto.toJson());

      //로그인 성공시
      if (response.statusCode == 200) {
        // 액세스 토큰 추출
        final String? accessToken = response.headers.value("access");

        // 리프레시 토큰 추출 (set-cookie 헤더에서)
        final List<String>? cookies = response.headers['set-cookie'];
        if (cookies != null) {
          final refreshToken = _extractCookieValue(cookies, "refresh");
          if (accessToken != null && refreshToken != null) {
            // 액세스, 리프레쉬 토큰 저장
            //await _storage.write(key: 'ACCESS_TOKEN', value: accessToken);ㅌ
            await _storage.write(
                key: 'ACCESS_TOKEN',
                value:
                    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjYXRlZ29yeSI6ImFjY2VzcyIsInVzZXJuYW1lIjoiamFuZyIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzM1MzY4NjQ5LCJleHAiOjE3MzUzNjkyNDl9.3DEecYW5HDTcIoc9Q5Z4vjmYZXOxJwz6ZlE8ydwMHu0');
            print("액세스 토큰 저장 완료");
            await _storage.write(key: 'REFRESH_TOKEN', value: refreshToken);
            print("리프레쉬 토큰 저장 완료");

            return true;
          }
        }
        throw Exception('토큰 정보가 없습니다.');
      } else {
        print('로그인 실패: ${response.data}');
        return false;
      }
    } catch (e) {
      print('로그인 요청 중 오류 발생: $e');
      return null;
    }
  }

// 쿠키 값 파싱 함수
  String? _extractCookieValue(List<String> cookies, String key) {
    for (String cookie in cookies) {
      if (cookie.startsWith(key)) {
        final parts = cookie.split(';').first.split('=');
        if (parts.length == 2 && parts[0].trim() == key) {
          return parts[1];
        }
      }
    }
    return null;
  }

  // 로그아웃(스토리지 토큰 삭제)
  Future<void> logout() async {
    final String? refresh = await _storage.read(key: 'REFRESH_TOKEN');
    final _logout = await _userProvider.logout(refresh!);
    try {
      if (_logout.statusCode == 200) {
        // storage의 액세스 토큰과 리프레시 토큰 삭제
        await _storage.delete(key: 'ACCESS_TOKEN');
        await _storage.delete(key: 'REFRESH_TOKEN');
        print("로그아웃 완료, 토큰 삭제");
      }
    } catch (e) {
      print("로그아웃 에러 : $e");
    }
  }

  // 로그인 상태 확인
  Future<bool> isLoggedIn(BuildContext context) async {
    // 액세스 토큰과 리프레시 토큰이 모두 존재하면 로그인 상태로 간주
    final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
    final refreshToken = await _storage.read(key: 'REFRESH_TOKEN');

    //토큰이 있을 경우, 토큰 유효성 검사
    if (accessToken != null && refreshToken != null) {
      final response =
          await _userProvider.validateToken(context, refreshToken!);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } else {
      print('로그인 상태 확인 에러');
      return false;
    }
  }

  // 사용자 정보 조회
  Future getUserInfo(BuildContext context) async {
    final String? accessToken = await _storage.read(key: 'ACCESS_TOKEN');
    final String? refreshToken = await _storage.read(key: 'REFRESH_TOKEN');

    if (accessToken == null || refreshToken == null) {
      throw Exception("로그인 정보가 없습니다.");
    }

    final response = await _userProvider.getUserInfo(context);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception("사용자 정보 불러오기 실패: ${response.data}");
    }
  }

  // 회원가입
  Future<void> signup(
      String name, String username, String password, String email) async {
    try {
      // 요청 데이터 생성
      SignupReqDto signupReqDto = SignupReqDto(username, password, name, email);

      Response response = await _userProvider.signup(signupReqDto.toJson());
      if (response.statusCode == 200) {
        print('회원가입 성공');
        Get.snackbar('회원가입 성공', '회원가입이 완료 됐습니다. 로그인을 진행해주세요!');
        Get.to(() => Login());
      } else {
        throw Exception('회원가입 실패: ${response.data}');
      }
    } catch (e) {
      print('회원가입 요청 중 오류 발생: $e');
    }
  }

  // ID 중복 확인
  Future<bool> isUseridTaken(String userid) async {
    try {
      return await _userProvider.isUseridTaken(userid);
    } catch (e) {
      print('ID 중복 확인 중 오류 발생: $e');
      return false;
    }
  }
}
