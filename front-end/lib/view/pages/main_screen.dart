import 'package:exercise_calendar/controller/main_controller.dart';
import 'package:exercise_calendar/view/pages/exercise_calender.dart';
import 'package:exercise_calendar/view/pages/exercise_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MainScreen extends StatelessWidget {
  final MainScreenController controller = Get.put(MainScreenController());

  final List<Widget> _screens = [
    ExerciseCalender(), // 캘린더 화면
    ExerciseHistory()
  ];
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '운동 캘린더',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '운동 조회',
              ),
              // 다른 항목 추가 가능
            ],
          )),
    );
  }
}
