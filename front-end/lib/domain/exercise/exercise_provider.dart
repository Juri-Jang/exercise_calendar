import 'package:dio/dio.dart';
import 'package:exercise_calendar/util/auth_dio.dart';
import 'package:flutter/material.dart';

class UserProvider {
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
}
