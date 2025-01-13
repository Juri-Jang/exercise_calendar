import 'package:dio/dio.dart';
import 'package:exercise_calendar/util/auth_dio.dart';
import 'package:exercise_calendar/util/jwt.dart';
import 'package:flutter/material.dart';

class ExerciseProvider {
  final Dio _dio = Dio();

  Future<Response> create(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      final Dio _dio = await authDio(context);
      final response = await _dio.post("/exercise/create", data: data);
      return response;
    } catch (e) {
      print('등록 실패: $e');
      rethrow;
    }
  }

  Future<Response> getByDate(BuildContext context, String date) async {
    try {
      final Dio _dio = await authDio(context);
      final response = await _dio
          .get("/exercise/getByDate", queryParameters: {'date': date});
      return response;
    } catch (e) {
      print('등록 실패: $e');
      rethrow;
    }
  }

  Future<Response> getAll(
      BuildContext context, String sortBy, String username) async {
    try {
      final Dio _dio = await authDio(context);
      final response = await _dio.get(
        "/exercise/getAll/$username",
        queryParameters: {'sortBy': sortBy},
      );
      return response;
    } catch (e) {
      print('운동 전체 목록 조회 실패 ');
      rethrow;
    }
  }
}
