import 'package:get/get.dart';

class SignupController extends GetxController {
  var password = ''.obs;
  var passwordCheck = ''.obs;

  // 두 비밀번호 필드가 일치하는지 확인
  // get => 읽기 전용 프로퍼티 (return 값x)
  // password 값과 password check 값이 같으면 true
  bool get passwordsMatch => password.value == passwordCheck.value;

  // 비밀번호 필드의 값이 변경될 때 호출
  void updatePassword(String value) {
    password.value = value;
  }

  // 비밀번호 확인 필드의 값이 변경될 때 호출
  void updatePasswordCheck(String value) {
    passwordCheck.value = value;
  }
}
