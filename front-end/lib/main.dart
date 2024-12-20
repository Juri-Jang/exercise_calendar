import 'package:exercise_calendar/controllers/user_controller.dart';
import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/components/main_screen.dart';
import 'package:exercise_calendar/view/pages/user/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();
  Get.put(UserController(),
      permanent: true); //앱 종료전까지 user controller 메모리에 유지(=> 로그인 상태 지속 관리)
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  UserRepository _userRepository = UserRepository();
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _userRepository.isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data == true ? MainScreen() : Login();
        },
      ),
    );
  }
}
