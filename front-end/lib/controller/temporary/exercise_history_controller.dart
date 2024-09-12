import 'package:get/get.dart';

class ExerciseHistoryController extends GetxController {
  var selectedOption = '최신 날짜'.obs; // 기본 값 설정

  final List<String> sortOptions = ['최신 날짜', '오래된 날짜', '평점'];

  void updateSelectedOption(String newOption) {
    selectedOption.value = newOption;
    // 여기에 선택된 옵션에 따라 데이터를 정렬하는 로직을 추가할 수 있습니다.
  }
}
