import 'package:exercise_calendar/controller/signupController.dart';
import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());

  final TextEditingController userName = TextEditingController();
  final TextEditingController userId = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordCheck = TextEditingController();
  final TextEditingController email = TextEditingController();

  UserRepository ur = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 95, 227),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "회원가입",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: userName,
                  decoration: InputDecoration(
                    labelText: '이름',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    child: TextField(
                      controller: userId,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      signupController.checkUserid(userId.text);
                    },
                    child: Text(
                      '중복확인',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: password,
                  obscureText: true,
                  onChanged: signupController.updatePassword, // 비밀번호 변경 시 호출
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: passwordCheck,
                  obscureText: true,
                  onChanged:
                      signupController.updatePasswordCheck, // 비밀번호 확인 변경 시 호출
                  decoration: InputDecoration(
                    labelText: '비밀번호 확인',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Obx(() {
                return Text(
                  signupController.passwordsMatch ? '' : '비밀번호가 일치하지 않습니다.',
                  style: TextStyle(color: Colors.red),
                );
              }),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: '이메일',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return ElevatedButton(
                      onPressed: signupController.isDone
                          ? () {
                              // 회원가입 완료 로직
                              ur.register(userId.text, userName.text,
                                  password.text, email.text);
                              Get.to(() => Login());
                            }
                          : null, // 비밀번호가 일치하지 않으면 버튼 비활성화
                      child: Text(
                        '회원가입',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      '뒤로가기',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
