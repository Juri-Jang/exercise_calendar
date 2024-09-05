import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var password = ''.obs;
  var passwordCheck = ''.obs;
  bool useridCheck = false;

  // 두 비밀번호 필드가 일치하는지 확인
  // get => 읽기 전용 프로퍼티 (return 값x)
  // password 값과 password check 값이 같으면 true
  bool get passwordsMatch => password.value == passwordCheck.value;

  bool isSignupValid() {
    if (passwordsMatch && useridCheck) {
      return true;
    } else {
      return false;
    }
  }

  // 비밀번호 필드의 값이 변경될 때 호출
  void updatePassword(String value) {
    password.value = value;
  }

  // 비밀번호 확인 필드의 값이 변경될 때 호출
  void updatePasswordCheck(String value) {
    passwordCheck.value = value;
  }

  // 중복 확인 함수
  Future<void> checkUserid(String userid) async {
    try {
      bool isTaken = await UserProvider().isUseridTaken(userid);
      if (isTaken) {
        Get.snackbar('중복 확인', '이미 존재하는 아이디입니다. \n다른 아이디를 사용해주세요.');
      } else {
        useridCheck = true;
        Get.snackbar('중복 확인', '사용 가능한 아이디입니다.');
      }
    } catch (e) {
      Get.snackbar('오류', '아이디 확인 중 문제가 발생했습니다.');
      print('e : $e');
    }
  }
}
