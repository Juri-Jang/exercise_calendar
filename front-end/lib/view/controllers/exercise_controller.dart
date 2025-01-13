import 'package:exercise_calendar/domain/exercise/exercise_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:exercise_calendar/view/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExerciseController extends GetxController {
  ExerciseRepository _exerciseRepository = new ExerciseRepository();
  UserController _userController = Get.find<UserController>();

  var userid = 0.obs;
  var selectedExercise = '배드민턴'.obs;
  var startTime = TimeOfDay.now().obs;
  var endTime = TimeOfDay.now().obs;
  TextEditingController description = TextEditingController();
  var rating = 1.obs;
  var exerciseList = <Map<String, dynamic>>[].obs;
  var file = ''.obs; // 첨부 파일

  var selectedDay = DateTime.now().obs;
  var exerciseDays = <DateTime>[].obs;

  @override
  void onInit() {
    userid.value = _userController.user_id.value;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getByDate(Get.context!, DateTime.now()); // 앱 시작 시 사용자 정보 로드
    // });
    getAll(Get.context!, "latest", "jang");
    super.onInit();
  }

  void createExercise(BuildContext context, DateTime dt, int num) {
    if (num == 0) {
      // 신규 등록
      _exerciseRepository.create(context, dt, selectedExercise.value,
          startTime.value, endTime.value, description.text, rating.value);

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

  void getAll(BuildContext context, String sortBy, String username) async {
    try {
      final response =
          await _exerciseRepository.getAll(context, sortBy, username);

      if (response.isNotEmpty) {
        var exercises = response[0]['exercises'];

        // exercise의 'date'가 null이 아닌 값만 DateTime으로 변환하여 exerciseDays에 추가
        exerciseDays = exercises
            .where((exercise) => exercise['date'] != null)
            .map((exercise) => DateTime.parse(exercise['date']))
            .toList();

        print('exerciseDays: $exerciseDays');
        print('exercises: $exercises');
      }
    } catch (e) {
      print('전체 날짜 불러오기 실패: $e');
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
