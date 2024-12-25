import 'package:exercise_calendar/view/controllers/user_controller.dart';
import 'package:exercise_calendar/view/pages/user/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class Login extends StatelessWidget {
  UserController u = Get.put(UserController());

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 88, 95, 227),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
                  Image.asset(
                    'assets/아령.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '오',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      Text(
                        '늘 ',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFD5D7F2)),
                      ),
                      Text(
                        '운',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      Text(
                        '동 ',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFD5D7F2)),
                      ),
                      Text(
                        '완',
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      Text(
                        '료',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFD5D7F2)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '오늘의 운동을 기록해 보세요!',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: username,
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "ID를 입력해주세요";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'ID',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: password,
                            onChanged: (value) {
                              _formKey.currentState!.validate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "비밀번호를 입력해주세요";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'PassWord',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // 로그인 시도
                              if (_formKey.currentState!.validate()) {
                                u.login(context, username.text, password.text);
                              }
                            },
                            child: Text(' 로그인'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {
                          // 구글 로그인
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/google.png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              '구글로 회원가입 하기',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // 회원가입 페이지 이동
                      Get.to(() => Signup());
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
