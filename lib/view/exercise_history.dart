import 'package:exercise_calendar/controller/exercise_controller.dart';
import 'package:exercise_calendar/controller/exercise_history_controller.dart';
import 'package:exercise_calendar/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/*
아이콘 출처 
배드민턴 : <a href="https://www.freepik.com/icon/badminton_15280817#fromView=search&page=1&position=82&uuid=1f7591e7-ba8d-4c7e-b5c5-9219f3323f73">Icon by IYIKON</a>
농구 : <a href="https://kr.freepik.com/icon/basketball_12094164#fromView=search&page=1&position=10&uuid=eca39620-89c5-4551-9bce-087439956087">Mihimihi 제작 아이콘</a>
축구 : <a href="https://kr.freepik.com/icon/football_2314715#fromView=search&page=1&position=74&uuid=0d15acb5-450b-4bc7-a95d-d3c30ade605b">Freepik 제작 아이콘</a>
*/
class ExerciseHistory extends StatelessWidget {
  ExerciseController c = Get.put(ExerciseController());
  ExerciseHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final ExerciseHistoryController hc = Get.put(ExerciseHistoryController());

    return Scaffold(
      appBar: CustomAppBar(title: '운동 조회'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight, // 드롭다운 버튼을 오른쪽 정렬
              child: Obx(() => DropdownButton<String>(
                    value: hc.selectedOption.value,
                    items: hc.sortOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        hc.updateSelectedOption(newValue);
                      }
                    },
                  )),
            ),
            // 추가적인 위젯이나 콘텐츠를 여기서 구성할 수 있습니다.
            Expanded(
              child: ListView.builder(
                itemCount: c.exerciseList.length,
                itemBuilder: ((context, index) {
                  String exerciseType = c.exerciseList[index]['종목'];
                  DateTime exerciseDate = c.exerciseList[index]['날짜'];
                  int exerciseRating = c.exerciseList[index]['평점'];
                  Widget leadingIcon;
                  switch (exerciseType) {
                    case '배드민턴':
                      leadingIcon = Image.asset('assets/badminton.png',
                          width: 30, height: 30);
                      break;
                    case '축구':
                      leadingIcon = Image.asset('assets/football.png',
                          width: 30, height: 30);
                      break;
                    case '농구':
                      leadingIcon = Image.asset('assets/basketball.png',
                          width: 30, height: 30);
                      break;
                    default:
                      leadingIcon = Icon(Icons.sports);
                      break;
                  }
                  return ListTile(
                    title: Text(exerciseType),
                    leading: leadingIcon,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd(EEE)', 'ko-KR')
                              .format(exerciseDate),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text('평점'),
                            SizedBox(width: 4),
                            Row(
                              children: List.generate(
                                5,
                                (i) => Icon(
                                  i < exerciseRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    onTap: () {
                      //상세보기로 이동
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
