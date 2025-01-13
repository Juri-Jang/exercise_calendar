import 'package:dio/dio.dart';
import 'package:exercise_calendar/domain/exercise/exercise_provider.dart';
import 'package:exercise_calendar/dto/CreateReqDto.dart';
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

  Future<List<Map<String, dynamic>>> getByDate(
      BuildContext context, DateTime date) async {
    try {
      String _date = formatDate(date);
      final response = await _exerciseProvider.getByDate(context, _date);
      return [response.data];
    } catch (e) {
      print('날짜별 운동 불러오기 실패 $e');
      return []; // 오류 발생 시 빈 리스트 반환
    }
  }

  Future<List<Map<String, dynamic>>> getAll(
      BuildContext context, String sortBy, String username) async {
    try {
      final response =
          await _exerciseProvider.getAll(context, sortBy, username);
      return [response.data];
    } catch (e) {
      ('전체 운동 조회 실패 $e');
      rethrow;
    }
  }
}
