import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  void LoginCheck(String username, String password) {
    if (username == "") {
      Get.snackbar('아이디', '아이디를 입력해주세요');
    }
    if (password == "") {
      Get.snackbar('비밀번호', '비밀번호를 입력해주세요');
    }
  }
}
