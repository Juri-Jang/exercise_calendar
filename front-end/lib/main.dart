import 'package:exercise_calendar/view/controllers/user_controller.dart';
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
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: loadUserInfoWithDelay(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return snapshot.data == true ? MainScreen() : Login();
        },
      ),
    );
  }

  Future<bool> loadUserInfoWithDelay() async {
    await Future.delayed(Duration(milliseconds: 200)); // 200ms 지연
    return Get.find<UserController>().loadUserInfo();
  }
}
