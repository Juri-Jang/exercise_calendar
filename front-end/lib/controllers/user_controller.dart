import 'package:exercise_calendar/domain/service/auth_service.dart';
import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  final AuthService _authService = AuthService();

  var name = "Guest".obs;
  var email = "guest@example.com".obs;

  Future<void> login(String username, String password) async {
    //로그인 로직 수행 후 토큰 저장
    bool result = await _authService.login(username, password);

    if (result == true) {
      //사용자 정보 불러옴(마이페이지 반영)
      Map<String, dynamic> response = await _userRepository.getUserInfo();
      name.value = response['name'];
      email.value = response['email'];

      Get.snackbar('로그인 성공', '$username님 반갑습니다!');
      Get.to(() => MainScreen());
    } else {
      Get.snackbar('로그인 실패', '아이디 또는 패스워드를 확인해주세요');
    }
  }
}
