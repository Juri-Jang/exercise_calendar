import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseController extends GetxController {
  var selectedExercise = '배드민턴'.obs;
  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;
  TextEditingController feedbackController = TextEditingController();
  var rating = 1.obs;
  var exerciseList = <Map<String, dynamic>>[].obs;
  var file = ''.obs; // 첨부 파일

  var selectedDay = DateTime.now().obs;
  var exerciseDays = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void registerExercise(DateTime dt, int num) {
    if (num == 0) {
      // 신규 등록
      exerciseList.add({
        '날짜': dt,
        '종목': selectedExercise.value,
        '시작시간': startTime.value,
        '종료시간': endTime.value,
        '운동기록': feedbackController.text,
        '평점': rating.value
      });
      if (!exerciseDays.contains(dt)) {
        exerciseDays.add(dt); // 운동 등록 시 날짜 추가
      }
    } else if (num == 1) {
      // 기존 내용 수정
      int index = exerciseList.indexWhere((exercise) =>
          exercise['날짜'] == dt && exercise['종목'] == selectedExercise.value);
      if (index != -1) {
        exerciseList[index] = {
          '날짜': dt,
          '종목': selectedExercise.value,
          '시작시간': startTime.value,
          '종료시간': endTime.value,
          '운동기록': feedbackController.text,
          '평점': rating.value
        };
      }
    }
    clear();
    Get.back();
    print('운동 등록 성공');
    printExercise();
  }

  void deleteExercise(int idx) {
    var exercise = exerciseList[idx]['종목'];
    var date = exerciseList[idx]['날짜'];
    exerciseList.removeAt(idx);

    // 해당 날짜의 운동 기록이 없으면 exerciseDays에서 제거
    if (!exerciseList.any((element) => element['날짜'] == date)) {
      exerciseDays.remove(date);
    }
    print(exercise + ' 삭제 완료');
  }

  void printExercise() {
    print(exerciseList);
  }

  void clear() {
    selectedExercise.value = '배드민턴';
    startTime = TimeOfDay.now().obs;
    endTime = TimeOfDay.now().obs;
    rating = 1.obs;
    feedbackController.clear();
    print('클리어 완');
  }

  void onDaySelected(DateTime day) {
    selectedDay.value = day;
  }
}
