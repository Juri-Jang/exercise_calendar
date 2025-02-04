import 'package:exercise_calendar/view/controllers/exercise_controller.dart';
import 'package:exercise_calendar/view/components/custom_drawer.dart';
import 'package:exercise_calendar/view/pages/post/exercise_create.dart';
import 'package:exercise_calendar/view/components/custom_appbar.dart';
import 'package:exercise_calendar/view/pages/post/exercise_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ExerciseCalender extends StatelessWidget {
  final ExerciseController c = Get.put(ExerciseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '운동 캘린더'),
      endDrawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 25),
        ),
        onPressed: () {
          if (c.selectedDay.value != null) {
            Get.to(() => ExerciseCreate(c.selectedDay.value, 0));
          } else {
            // selectedDay가 null인 경우의 처리
            print("Selected day is null");
          }
        },
      ),
      body: Obx(
        () => Column(
          children: [
            TableCalendar(
              locale: 'ko_KR',
              focusedDay: c.selectedDay.value,
              firstDay: DateTime(2024),
              lastDay: DateTime(2030),
              selectedDayPredicate: (day) {
                // 선택된 날짜 상태를 반영
                return isSameDay(day, c.selectedDay.value);
              },
              onDaySelected: (selectedDay, focusedDay) {
                // 선택된 날짜를 컨트롤러의 상태로 변경
                c.onDaySelected(selectedDay);
              },
              daysOfWeekHeight: 40,
              headerStyle:
                  HeaderStyle(titleCentered: true, formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                weekendTextStyle: TextStyle(color: Colors.red),
                markersAlignment: Alignment.bottomCenter,
                markersAutoAligned: true,
                isTodayHighlighted: true,
                outsideDaysVisible: true,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle:
                    TextStyle(color: Colors.red), // 주말의 요일 텍스트 색상을 빨간색으로 설정
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, focusedDay) {
                  return Obx(() {
                    // 상태 변화를 감지하여 마커를 동적으로 렌더링
                    if (c.exerciseDays.any((d) => isSameDay(d, day))) {
                      return Positioned(
                        child: Image.asset(
                          'assets/아령.png',
                          width: 20,
                          height: 20,
                        ),
                      );
                    }
                    return SizedBox.shrink(); // 빈 위젯 반환
                  });
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Color(0xFF8389F8),
                borderRadius: BorderRadius.circular(10),
              ),
              width: MediaQuery.of(context).size.width * 0.95,
              height: 30,
              child: Obx(() => Text(
                    DateFormat('yyyy년 MM월 dd일 (EEE)', 'ko-KR')
                        .format(c.selectedDay.value),
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  )),
            ),
            Expanded(
              child: Obx(
                () {
                  var selectedDayExercises = c.exerciseList
                      .where((exercise) =>
                          isSameDay(exercise['date'], c.selectedDay.value))
                      .toList();
                  return ListView.builder(
                    itemCount: selectedDayExercises.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(selectedDayExercises[index]['category']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.to(() => ExerciseCreate(
                                      c.selectedDay.value, 1,
                                      exercise: selectedDayExercises[index]));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  // 삭제 로직
                                  int id = selectedDayExercises[index]['id'];
                                  c.deleteExercise(context, id);
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                        onTap: () async {
                          int id = selectedDayExercises[index]['id'];
                          await c.getDetail(id);
                          Get.to(ExerciseDetail(
                              id, selectedDayExercises[index]['category']));
                        },
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
