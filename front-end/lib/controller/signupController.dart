import 'package:exercise_calendar/domain/user/user_provider.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var passwordCheck = ''.obs;
  var email = ''.obs;
  var check = false.obs;
  bool get isDone => check.value;

  var isUsernameValid = true.obs; // 아이디 유효성
  var isEmailValid = true.obs; // 이메일 유효성

  // 두 비밀번호 필드가 일치하는지 확인
  // get => 읽기 전용 프로퍼티 (return 값x)
  // password 값과 password check 값이 같으면 true
  bool get passwordsMatch => password.value == passwordCheck.value;

  // 아이디 필드의 값이 변경될 때 호출
  void updateUsername(String value) {
    username.value = value;
    if (value.isEmpty) {
      isUsernameValid.value = false;
    } else {
      isUsernameValid.value = true;
    }
    checkIfDone();
  }

  // 비밀번호 필드의 값이 변경될 때 호출
  void updatePassword(String value) {
    password.value = value;
  }

  // 비밀번호 확인 필드의 값이 변경될 때 호출
  void updatePasswordCheck(String value) {
    passwordCheck.value = value;
  }

  // 이메일 필드의 값이 변경될 때 호출
  void updateEmail(String value) {
    email.value = value;
    if (value.isEmpty) {
      isEmailValid.value = false;
    } else {
      isEmailValid.value = true;
    }
    checkIfDone();
  }

  // 중복 확인 함수
  Future<void> checkUserid(String userid) async {
    try {
      bool isTaken = await UserProvider().isUseridTaken(userid);
      if (isTaken) {
        Get.snackbar('중복 확인', '이미 존재하는 아이디입니다. \n다른 아이디를 사용해주세요.');
      } else {
        Get.snackbar('중복 확인', '사용 가능한 아이디입니다.');
        if (passwordsMatch) {
          check.value = true;
        }
      }
    } catch (e) {
      Get.snackbar('오류', '아이디 확인 중 문제가 발생했습니다.');
      print('e : $e');
    }
  }

  // 모든 필드가 유효할 때만 회원가입 가능 상태로 설정
  void checkIfDone() {
    if (isUsernameValid.value && passwordsMatch && isEmailValid.value) {
      check.value = true;
    } else {
      check.value = false;
    }
  }
}
