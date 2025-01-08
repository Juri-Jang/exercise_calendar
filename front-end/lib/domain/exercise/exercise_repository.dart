import 'package:dio/dio.dart';
import 'package:exercise_calendar/domain/user/user.dart';
import 'package:exercise_calendar/dto/createReqDto.dart';
import 'package:flutter/material.dart';

class ExerciseRepository {
  ExerciseRepository _exerciseRepository = new ExerciseRepository();

  Future<void> create(
      int id,
      String category,
      TimeOfDay createTime,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String description,
      int rating) async {
    try {
      CreateReqDto dto = CreateReqDto(
          category, createTime, startTime, endTime, description, rating);
      Response response = await _exerciseRepository.create(dto.toJson() as int);
    } catch (e) {
      throw Exception('운동 등록 실패: ${response.data}');
    }
  }
}
