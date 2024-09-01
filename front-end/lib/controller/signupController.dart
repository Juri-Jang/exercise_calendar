import 'package:get/get.dart';

class SignupController extends GetxController {
  var password = ''.obs;
  var passwordCheck = ''.obs;

  // 두 비밀번호 필드가 일치하는지 확인
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
