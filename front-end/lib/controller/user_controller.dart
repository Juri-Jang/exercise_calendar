import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/util/jwt.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  Future<void> login(String username, String password) async {
    String token = await _userRepository.login(username, password);
    jwtToken = token;

    if (jwtToken == "로그인 실패") {
      Get.snackbar('로그인 실패', '아이디 또는 패스워드를 확인해주세요');
    } else {
      Get.snackbar('로그인 성공', '$username님 반갑습니다!');
      Get.to(() => MainScreen());
    }
  }
}
