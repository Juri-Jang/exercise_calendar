import 'package:dio/dio.dart';
import 'package:exercise_calendar/util/auth_dio.dart';
import 'package:exercise_calendar/util/constants.dart';
import 'package:flutter/material.dart';

class UserProvider {
  final Dio _dio = Dio();

  // 로그인 요청
  Future<Response> login(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      final Dio _dio = await authDio(context);
      final response = await _dio.post(
        "/login",
        data: data,
      );
      return response;
    } catch (e) {
      print('로그인 실패: $e');
      rethrow;
    }
  }

  // 사용자 정보 조회
  Future<Response> getUserInfo(BuildContext context) async {
    try {
      final Dio _dio = await authDio(context);
      final response = await _dio.get(
        "/user/profile",
      );
      return response;
    } catch (e) {
      print('사용자 정보 조회 실패: $e');
      rethrow;
    }
  }

  Future<Response> logout(String refresh) async {
    try {
      Response response = await _dio.post(
        "$BASE_URL/logout",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Cookie': 'refresh=$refresh',
          },
        ),
      );
      return response;
    } catch (e) {
      print('로그아웃 에러 $e');
      rethrow;
    }
  }
  // 리프레시 토큰을 이용하여 새로운 액세스 토큰 발급
  // Future<Response> reissueToken(String refreshToken) async {
  //   try {
  //     Response response = await _dio.post(
  //       "$BASE_URL/reissue", // 리프레시 토큰을 받아 새로운 액세스 토큰을 발급하는 API
  //       options: Options(
  //         headers: {'Content-Type': 'application/json'}, // 헤더 설정
  //       ),
  //     );
  //     return response;
  //   } catch (e) {
  //     rethrow; // 에러를 호출한 곳으로 다시 던짐
  //   }
  // }

  // 회원가입 요청
  Future<Response> register(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(
        "$BASE_URL/user/register",
        data: data,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // ID 중복 확인
  Future<bool> isUseridTaken(String username) async {
    try {
      Response response = await _dio.get(
        "$BASE_URL/user/check-userid/$username",
      );
      if (response.statusCode == 200) {
        return response.data as bool;
      }
      throw Exception('ID 중복 확인 실패');
    } catch (e) {
      rethrow;
    }
  }
}
