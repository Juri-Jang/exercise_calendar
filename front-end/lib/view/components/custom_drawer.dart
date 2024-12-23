import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exercise_calendar/view/controllers/user_controller.dart';
import 'package:exercise_calendar/view/pages/user/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Widget CustomDrawer() {
  final UserController _userController = Get.find<UserController>();
  final UserRepository _userRepository = UserRepository();

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Obx(() => UserAccountsDrawerHeader(
              accountName: Text(
                _userController.name.value.isNotEmpty
                    ? _userController.name.value
                    : "Guest",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                _userController.email.value.isNotEmpty
                    ? _userController.email.value
                    : "guest@example.com",
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  _userController.name.value.isNotEmpty
                      ? _userController.name.value[0].toUpperCase()
                      : "G",
                  style: TextStyle(fontSize: 40.0, color: Colors.deepPurple),
                ),
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 88, 95, 227),
              ),
            )),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            // 설정 화면으로 이동
            //Get.to(() => SettingsPage()); // SettingsPage를 구현한 화면으로 이동
            final _storage = new FlutterSecureStorage();
            void printSecureStorage() async {
              // 모든 데이터 읽기
              Map<String, String> allValues = await _storage.readAll();

              // 콘솔에 출력
              print(allValues);
            }

            printSecureStorage();
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // 로그아웃 처리
            _userController.name.value = "Guest";
            _userController.email.value = "guest@example.com";
            _userRepository.logout();
            Get.snackbar("Logout", "Logged out successfully!",
                snackPosition: SnackPosition.BOTTOM);

            // 로그인 화면으로 이동
            Get.offAll(() => Login());
          },
        ),
      ],
    ),
  );
}
