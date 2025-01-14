import 'package:exercise_calendar/domain/exercise/exercise_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:exercise_calendar/view/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseController extends GetxController {
  ExerciseRepository _exerciseRepository = new ExerciseRepository();
  UserController _userController = Get.find<UserController>();

  var selectedDay = DateTime.now().obs;
  var exerciseDays = <DateTime>[].obs; // 운동이 있는 날짜 리스트

  var userid = 0.obs;
  var username = "".obs;
  var selectedExercise = '배드민턴'.obs;
  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;
  TextEditingController description = TextEditingController();
  var rating = 1.obs;
  var exerciseList = <dynamic>[].obs;
  var file = ''.obs; // 첨부 파일

  @override
  void onInit() {
    userid.value = _userController.user_id.value;
    username.value = _userController.username.value;

    _loadAllExercises(username.value);
    super.onInit();
  }

  Future<void> _loadAllExercises(String username) async {
    try {
      final response =
          await _exerciseRepository.getAll(Get.context!, "latest", username);

      // 각 항목의 'date'를 DateTime으로 변환 후 바로 exerciseList에 추가
      final updatedExercises = response.map((e) {
        final dateString = e['date']; // 날짜 문자열 추출
        if (dateString == null) {
          throw Exception('Missing date field in exercise: $e');
        }
        final date = DateTime.parse(dateString); // 문자열을 DateTime으로 변환
        return {
          ...e,
          'date': date, // 변환된 DateTime을 'date'로 덮어씀
        };
      }).toList();

      // 변환된 데이터를 exerciseList에 추가
      exerciseList.addAll(updatedExercises);

      final newExerciseDays = updatedExercises.map((e) {
        return e['date'] as DateTime;
        ; // 각 항목에서 'date'만 추출
      }).toList(); // 중복 검사 없이 날짜 추가

      exerciseDays.addAll(newExerciseDays);
    } catch (e) {
      print('모든 운동 데이터 로드 실패: $e');
    }
  }

  void createExercise(BuildContext context, DateTime dt, int num) {
    if (num == 0) {
      // 신규 등록
      //DB에 저장
      _exerciseRepository.create(context, dt, selectedExercise.value,
          startTime.value, endTime.value, description.text, rating.value);

      //캐시 역할
      exerciseList.add(
        {
          '날짜': dt,
          '종목': selectedExercise.value,
          '시작시간': startTime.value,
          '종료시간': endTime.value,
          '운동기록': description.text,
          '평점': rating.value
        },
      );
      if (!exerciseDays.contains(dt)) {
        exerciseDays.add(dt); // 운동 등록 시 날짜 추가
        print('days: $exerciseDays');
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
          '운동기록': description.text,
          '평점': rating.value
        };
      }
    }
    clear();
    Get.off(
        MainScreen()); //달력 ui에 exerciseDays 추가를 실시간 반영하기 위해 ExerciseCalender로 이동
    print('운동 등록 성공');
    printExercise();
  }

  void getByDate(BuildContext context, DateTime date) async {
    try {
      final response = await _exerciseRepository.getByDate(context, date);
      if (response.isNotEmpty) {
        exerciseList.addAll(response);
      }
      print('exercise : ${exerciseList.value}');
    } catch (e) {
      print('날짜별 운동 불러오기 실패 $e');
    }
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
    description.clear();
  }

  void onDaySelected(DateTime day) {
    selectedDay.value = day;
  }
}
