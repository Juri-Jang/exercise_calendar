import 'package:exercise_calendar/domain/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:exercise_calendar/controllers/user_controller.dart';
import 'package:exercise_calendar/view/pages/user/login.dart'; // 로그아웃 후 이동할 Login 페이지 import

Widget CustomDrawer() {
  final UserController userController = Get.find<UserController>();
  final AuthService _authService = AuthService();

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Obx(() => UserAccountsDrawerHeader(
              accountName: Text(
                userController.name.value.isNotEmpty
                    ? userController.name.value
                    : "Guest",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                userController.email.value.isNotEmpty
                    ? userController.email.value
                    : "guest@example.com",
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userController.name.value.isNotEmpty
                      ? userController.name.value[0].toUpperCase()
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
          },
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
          onTap: () {
            // 로그아웃 처리
            userController.name.value = "Guest";
            userController.email.value = "guest@example.com";
            _authService.logout();
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
