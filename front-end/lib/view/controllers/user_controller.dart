import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();
  var user_id = 0.obs;
  var username = "".obs;
  var name = "Guest".obs;
  var email = "guest@example.com".obs;
  final _storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserInfo(); // 앱 시작 시 사용자 정보 로드
    });
  }

  // 로그인 상태 확인 및 사용자 정보 로딩
  Future<bool> loadUserInfo() async {
    if (Get.context != null) {
      final isLoggedIn = await _userRepository.isLoggedIn(Get.context!);
      if (isLoggedIn) {
        await _fetchAndSetUserInfo(); // 로그인 상태라면 사용자 정보 로드
        return true;
      } else {
        print('로그인 정보 없음');
        return false;
      }
    } else {
      print("Get.context is null");
      return false;
    }
  }

  // 사용자 정보를 가져와서 저장하는 함수 (로그인/앱 시작 시 공통)
  Future<void> _fetchAndSetUserInfo() async {
    try {
      final userInfo = await _userRepository.getUserInfo(Get.context!);
      name.value = userInfo['name'] ?? 'Guest'; // null 값 처리
      email.value = userInfo['email'] ?? 'guest@example.com'; // null 값 처리
      user_id.value = userInfo['id'] ?? 0;
      username.value = userInfo['username'] ?? "";
    } catch (e) {
      print('사용자 정보 로딩 실패: $e');
    }
  }

  // 로그인 함수 - 로그인 후 사용자 정보를 가져오기
  Future<bool?> login(
      BuildContext context, String username, String password) async {
    try {
      bool? result = await _userRepository.login(context, username, password);

      if (result == true) {
        await _fetchAndSetUserInfo(); // 로그인 후 사용자 정보 가져오기
        Get.snackbar('로그인 성공', '$username님 반갑습니다!');
        Get.to(() => MainScreen());
        return true;
      } else {
        Get.snackbar('로그인 실패', '아이디 또는 패스워드를 확인해주세요');
        return false;
      }
    } catch (e) {
      print('로그인 실패: $e');
      return false;
    }
  }
}
