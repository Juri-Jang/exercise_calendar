import 'package:exercise_calendar/controllers/signupController.dart';
import 'package:exercise_calendar/domain/user/user_repository.dart';
import 'package:exercise_calendar/view/pages/user/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Signup extends StatelessWidget {
  final SignupController signupController = Get.put(SignupController());

  final TextEditingController name = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordCheck = TextEditingController();
  final TextEditingController email = TextEditingController();

  final _formKey = GlobalKey<FormState>(); //유효성 검사를 위한 Form 위젯

  UserRepository ur = UserRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 88, 95, 227),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Form(
            key: _formKey, //유효성 검사를 위한 key
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
                  child: TextFormField(
                    controller: name,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "이름을 입력해주세요";
                      }
                      return null;
                    },
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
                      child: TextFormField(
                        controller: username,
                        onChanged: (value) {
                          _formKey.currentState!.validate();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "아이디를 입력해주세요";
                          }
                          return null;
                        },
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
                        signupController.checkUserid(username.text);
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
                  child: TextFormField(
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
                  child: TextFormField(
                    controller: passwordCheck,
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
                  child: TextFormField(
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "이메일을 입력해주세요";
                      }
                      return null;
                    },
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
                                if (_formKey.currentState!.validate()) {
                                  // 회원가입 완료 로직
                                  ur.signup(name.text, username.text,
                                      password.text, email.text);
                                  Get.snackbar(
                                      '회원가입 성공', '회원가입이 완료 됐습니다. 로그인을 진행해주세요!');
                                  signupController.init();
                                  Get.to(() => Login());
                                }
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
      ),
    );
  }
}
