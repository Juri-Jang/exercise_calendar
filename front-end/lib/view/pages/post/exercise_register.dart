import 'package:exercise_calendar/view/controllers/exercise_controller.dart';
import 'package:exercise_calendar/view/components/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class ExerciseRegister extends StatelessWidget {
  final ExerciseController c = Get.put(ExerciseController());
  final DateTime selectDay;
  final int num; // 0:신규등록, 1:수정
  final Map<String, dynamic>? exercise;

  ExerciseRegister(this.selectDay, this.num, {this.exercise});

  @override
  Widget build(BuildContext context) {
    if (num == 1) {
      print('data$exercise');
      // 수정 모드일 때 기존 데이터를 컨트롤러에 설정
      c.selectedExercise.value = exercise!['종목'];
      c.startTime.value = exercise!['시작시간'];
      c.endTime.value = (exercise!['종료시간']);
      c.feedbackController.text = exercise!['운동기록'];
      c.rating.value = exercise!['평점'];
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: num != 1 ? '운동 등록' : '운동 수정',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xFF8389F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 30,
                  child: Obx(() => Text(
                        DateFormat('yyyy년 MM월 dd일 (EEE)', 'ko-KR')
                            .format(c.selectedDay.value),
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                ),
              ),
              SizedBox(height: 20),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: c.selectedExercise.value,
                  onChanged: (value) {
                    c.selectedExercise.value = value!;
                  },
                  items: ['배드민턴', '축구', '농구'].map((exercise) {
                    return DropdownMenuItem(
                      value: exercise,
                      child: Text(exercise),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '종목',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '시작 시간',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(width: 140),
                  Text(
                    '종료 시간',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => TimePickerSpinnerPopUp(
                        mode: CupertinoDatePickerMode.time,
                        initTime: DateTime(
                          selectDay.year,
                          selectDay.month,
                          selectDay.day,
                          c.startTime.value.hour,
                          c.startTime.value.minute,
                        ),
                        onChange: (dateTime) {
                          c.startTime.value = TimeOfDay.fromDateTime(dateTime);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Obx(
                      () => TimePickerSpinnerPopUp(
                        mode: CupertinoDatePickerMode.time,
                        initTime: DateTime(
                          selectDay.year,
                          selectDay.month,
                          selectDay.day,
                          c.endTime.value.hour,
                          c.endTime.value.minute,
                        ),
                        onChange: (dateTime) {
                          c.endTime.value = TimeOfDay.fromDateTime(dateTime);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Obx(() {
                final startTime = c.startTime.value;
                final endTime = c.endTime.value;

                // 시작 시간과 종료 시간을 DateTime으로 변환하여 차이 계산
                final startDateTime = DateTime(selectDay.year, selectDay.month,
                    selectDay.day, startTime.hour, startTime.minute);
                final endDateTime = DateTime(selectDay.year, selectDay.month,
                    selectDay.day, endTime.hour, endTime.minute);

                // 두 시간 사이의 Duration 계산
                final duration = endDateTime.difference(startDateTime);
                final durationText = duration.isNegative
                    ? "잘못된 시간 설정"
                    : "${duration.inHours}시간 ${duration.inMinutes % 60}분";
                return Text(
                  "총 소요시간: $durationText",
                  style: TextStyle(fontSize: 12, color: Colors.black),
                );
              }),
              SizedBox(height: 16),
              Text('운동 기록'),
              SizedBox(height: 10),
              TextField(
                controller: c.feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '오늘의 운동이 어땠나요?',
                ),
              ),
              SizedBox(height: 16),
              Text(
                '운동 평가',
                style: TextStyle(fontSize: 14),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Obx(() => IconButton(
                        icon: Icon(
                          index < c.rating.value
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          c.rating.value = index + 1;
                        },
                      ));
                }),
              ),
              Text('첨부'),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '첨부 파일을 등록하세요',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      '선택하기',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 88, 95, 227),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    c.registerExercise(selectDay, num);
                  },
                  child: num != 1
                      ? Text('등록', style: TextStyle(color: Colors.white))
                      : Text('수정', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 88, 95, 227),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
