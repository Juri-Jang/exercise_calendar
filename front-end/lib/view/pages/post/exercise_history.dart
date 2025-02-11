import 'package:exercise_calendar/view/controllers/exercise_controller.dart';
import 'package:exercise_calendar/view/controllers/exercise_history_controller.dart';
import 'package:exercise_calendar/view/components/custom_appbar.dart';
import 'package:exercise_calendar/view/components/custom_drawer.dart';
import 'package:exercise_calendar/view/pages/post/exercise_detail.dart';
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
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(title: '운동 조회'),
      endDrawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "운동을 검색하세요",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.circular(10)),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 20,
                          ),
                        ),
                        onChanged: (value) {
                          hc.updateSearchQuery(value); // 검색어 업데이트
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    DropdownButton<String>(
                      value: hc.selectedOption.value,
                      items: hc.sortOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          hc.updateSelectedOption(newValue);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                // 검색어가 있으면 필터링된 목록을, 없으면 전체 목록을 보여줌
                var filteredList = hc.searchQuery.value.isEmpty
                    ? c.exerciseList // 검색어가 없으면 전체 목록
                    : c.exerciseList.where((exercise) {
                        return exercise['category']
                            .toString()
                            .contains(hc.searchQuery.value);
                      }).toList();

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: ((context, index) {
                    int id = filteredList[index]['id'];
                    String category = filteredList[index]['category'];
                    DateTime exerciseDate = filteredList[index]['date'];
                    int exerciseRating = filteredList[index]['rating'];
                    Widget leadingIcon;
                    switch (category) {
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
                      title: Text(category),
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
                      onTap: () async {
                        await c.getDetail(id);
                        Get.to(ExerciseDetail(id, category));
                      },
                    );
                  }),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
