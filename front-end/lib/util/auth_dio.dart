import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:exercise_calendar/util/constants.dart';
import 'package:exercise_calendar/view/pages/user/login.dart';
import 'package:get/get.dart';

Future authDio(BuildContext context) async {
  var dio = Dio();
  final _storage = FlutterSecureStorage();

  // 기존 인터셉터들을 지우고 새로운 인터셉터를 설정
  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(
    // 요청을 보내기 전에 액세스 토큰을 헤더에 추가
    onRequest: (options, handler) async {
      final accessToken = await _storage.read(key: 'ACCESS_TOKEN');
      options.baseUrl = BASE_URL;
      options.headers.addAll({
        'access': accessToken,
        'Content-Type': 'application/json',
      });
      return handler.next(options); // 요청을 계속 진행
    },
    onError: (error, handler) async {
      //401 오류(id / pw 유효성 오류)가 발생한 경우 처리
      if (error.response?.statusCode == 401) {
        // 로그인 실패 처리
        Get.snackbar('로그인 실패', '아이디 또는 패스워드를 확인해주세요');
        Get.offAll(() => Login());
      }

      // 403 오류(jwt토큰 만료 실패)가 발생한 경우 처리
      if (error.response?.statusCode == 403) {
        // 토큰 만료 시, 한 번만 리프레시 토큰을 요청하도록 방지
        final refreshToken = await _storage.read(key: 'REFRESH_TOKEN');
        if (refreshToken == null) {
          await _storage.deleteAll();
          Get.snackbar('로그인 인증 만료', '로그인 인증이 만료 되었습니다. 다시 로그인해주세요!');
          Get.offAll(() => Login());
          return;
        }

        var refreshDio = Dio();
        refreshDio.options.baseUrl = BASE_URL;

        try {
          final refreshResponse = await refreshDio.post(
            '/reissue',
            options: Options(headers: {
              'X-Refresh-Token': refreshToken, // 리프레시 토큰 헤더로 전달
              'Content-Type': 'application/json',
            }),
          );

          if (refreshResponse.statusCode == 200) {
            // 새로운 액세스 토큰과 리프레시 토큰을 받아서 저장
            final newAccessToken = refreshResponse.headers.value('access');
            final newRefreshToken =
                refreshResponse.headers.value('X-Refresh-Token');

            if (newAccessToken != null) {
              await _storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
            }
            if (newRefreshToken != null) {
              await _storage.write(
                  key: 'REFRESH_TOKEN', value: newRefreshToken);
            }

            // 새로운 액세스 토큰을 요청에 추가
            error.requestOptions.headers['access'] = newAccessToken;

            // 기존 요청을 새로운 액세스 토큰으로 다시 시도
            final clonedRequest = await dio.request(
              error.requestOptions.path,
              options: Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              ),
              data: error.requestOptions.data,
              queryParameters: error.requestOptions.queryParameters,
            );

            // 성공적으로 요청을 처리하고 재발급된 토큰을 다시 사용
            return handler.resolve(clonedRequest); // 수정된 요청으로 응답 처리
          }
        } catch (e) {
          await _storage.deleteAll();
          Get.snackbar('로그인 인증 만료', '로그인 인증이 만료 되었습니다. 다시 로그인해주세요!');
          Get.offAll(() => Login());
          return;
        }
      }

      // 오류가 계속 발생하면 오류를 그대로 전달
      return handler.next(error);
    },
  ));

  return dio; // 설정된 dio 반환
}
