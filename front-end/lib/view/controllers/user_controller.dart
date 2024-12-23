import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  var name = "Guest".obs;
  var email = "guest@example.com".obs;
  final _storage = new FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    printSecureStorage();
  }

  void printSecureStorage() async {
    // 모든 데이터 읽기
    Map<String, String> allValues = await _storage.readAll();

    // 콘솔에 출력
    print('hihi : $allValues');
  }

  Future<void> _loadUserInfo() async {
    try {
      // 로그인 상태라면 사용자 정보를 로드
      final userInfo = await _userRepository.getUserInfo();
      name.value = userInfo['name'] ?? "Guest";
      email.value = userInfo['email'] ?? "guest@example.com";
    } catch (e) {
      print('사용자 정보 로딩 실패: $e');
    }
  }

  Future<void> login(
      BuildContext context, String username, String password) async {
    //로그인 로직 수행 후 토큰 저장
    bool? result = await _userRepository.login(context, username, password);

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
