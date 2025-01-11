import 'package:dio/dio.dart';
import 'package:exercise_calendar/domain/exercise/exercise_provider.dart';
import 'package:exercise_calendar/dto/createReqDto.dart';
import 'package:flutter/material.dart';

class ExerciseRepository {
  ExerciseProvider _exerciseProvider = new ExerciseProvider();

  // TimeOfDay -> LocalTime 형식 변환 함수
  String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }

  // DateTime -> LocalDate 형식 변환 함수
  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> create(
      BuildContext context,
      DateTime date,
      String category,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String description,
      int rating) async {
    try {
      String formattedDate = formatDate(date);
      String formattedStartTime = formatTimeOfDay(startTime);
      String formattedEndTime = formatTimeOfDay(endTime);

      // CreateReqDto 생성
      CreateReqDto dto = CreateReqDto(
        category: category,
        date: formattedDate,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        description: description,
        rating: rating,
      );

      Response response = await _exerciseProvider.create(context, dto.toJson());
    } catch (e) {
      throw Exception('운동 등록 실패: $e');
    }
  }
}
