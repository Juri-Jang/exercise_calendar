import 'package:exercise_calendar/view/controllers/exercise_controller.dart';
import 'package:exercise_calendar/view/components/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExerciseDetail extends StatelessWidget {
  final ExerciseController c = Get.put(ExerciseController());
  final int id;
  final String category;

  ExerciseDetail(this.id, this.category);

  @override
  Widget build(BuildContext context) {
    final Map<String, String> categoryImages = {
      '배드민턴': 'assets/badminton.png',
      '축구': 'assets/football.png',
      '농구': 'assets/basketball.png',
    };

    return Scaffold(
      appBar: CustomAppBar(title: '운동 조회'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜
            Center(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF8389F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 30,
                child: GetBuilder<ExerciseController>(
                  builder: (_) => Text(
                    DateFormat('yyyy년 MM월 dd일 (EEE)', 'ko-KR')
                        .format(c.selectedDay.value),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // 카테고리
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        categoryImages.containsKey(category)
                            ? Image.asset(categoryImages[category]!,
                                width: 40, height: 40)
                            : Icon(Icons.sports, size: 40),
                        SizedBox(width: 8),
                        Text(
                          category,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // 소요 시간
            Center(child: _buildTimeSection()),
            SizedBox(height: 20),
            // 운동 기록
            Center(child: _buildDescriptionSection()),
            SizedBox(height: 20),
            // 운동 평가
            Center(child: _buildRatingSection()),
          ],
        ),
      ),
    );
  }

  //시간 변환 함수 (String → DateTime)
  DateTime parseDateTime(String timeString, DateTime baseDate) {
    List<String> parts =
        timeString.split(":"); // "23:34:00" → ["23", "34", "00"]
    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  Widget _buildTimeSection() {
    final date = c.detail['date'];
    final startTimeString = c.detail['startTime'];
    final endTimeString = c.detail['endTime'];

    //String → DateTime 변환
    final startDateTime = parseDateTime(startTimeString, date);
    final endDateTime = parseDateTime(endTimeString, date);

    //시간 차이 계산
    final duration = endDateTime.difference(startDateTime);
    final durationText = duration.isNegative
        ? "잘못된 시간 설정"
        : "${duration.inHours}시간 ${duration.inMinutes % 60}분";

    return Container(
      width: 500,
      height: 130,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('시작 시간',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('종료 시간',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(DateFormat("HH:mm").format(startDateTime),
                      style: TextStyle(fontSize: 16)),
                  Text(DateFormat("HH:mm").format(endDateTime),
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 10),
              Center(
                child: Text("총 소요시간: $durationText",
                    style: TextStyle(fontSize: 14, color: Colors.black54)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Container(
      width: 500,
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('운동 기록',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GetBuilder<ExerciseController>(
                builder: (_) => Text(c.detail['description'],
                    style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      width: 500,
      height: 110,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('운동 평가',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GetBuilder<ExerciseController>(
                builder: (_) {
                  int rating = c.detail['rating'] ?? 0;
                  return Wrap(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 30,
                      );
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
