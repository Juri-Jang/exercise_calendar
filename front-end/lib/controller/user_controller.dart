import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/util/jwt.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  Future<void> login(String username, String password) async {
    String token = await _userRepository.login(username, password);
    jwtToken = token;
    print('토큰 $jwtToken');
  }
}
