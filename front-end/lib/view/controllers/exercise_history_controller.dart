import 'package:exercise_calendar/view/controllers/exercise_controller.dart';
import 'package:exercise_calendar/view/controllers/user_controller.dart';
import 'package:get/get.dart';

class ExerciseHistoryController extends GetxController {
  final ExerciseController _exerciseController = Get.find<ExerciseController>();
  final UserController _userController = Get.find<UserController>();

  var selectedOption = '최신 날짜'.obs;
  String username = "";
  var searchQuery = ''.obs;

  final List<String> sortOptions = ['최신 날짜', '오래된 날짜', '평점 높은 순'];

  @override
  void onInit() {
    super.onInit();

    username = _userController.username.value;
  }

  void updateSelectedOption(String newOption) async {
    selectedOption.value = newOption;
    try {
      switch (newOption) {
        case '최신 날짜':
          _exerciseController.loadAllExercises(username, "latest");
          break;
        case '오래된 날짜':
          _exerciseController.loadAllExercises(username, "oldest");
          break;
        case '평점 높은 순':
          _exerciseController.loadAllExercises(username, "highestRating");
          break;
      }
    } catch (e) {
      print('모든 운동 데이터 로드 실패: $e');
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
}
