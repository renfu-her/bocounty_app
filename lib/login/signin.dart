// import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:app/login/login.dart';
import 'package:http/http.dart' as http;

import 'package:app/main.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _focusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Timer(Duration(seconds: 2), () {
        //   Navigator.of(context).pop();
        // });

        return const AlertDialog(
          content: SizedBox(
            height: 100,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  Text(
                    '已發送認證信至',
                  ),
                  Text(
                    '東華大學帳號的信箱！',
                  ),
                  Text(
                    '請前往確認',
                  ),
                ],
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(top: 35, right: 20, left: 20),
        );
      },
    );
    print('註冊成功');
    await Future.delayed(const Duration(seconds: 3));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<void> _signin(apiUrl) async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String passwordConfirm = _passwordConfirmController.text;

    // 構建登錄請求的資料
    Map<String, String> data = {
      'student_id': username,
      'name': username,
      'password': password,
    };

    if (username == "" || password == "" || passwordConfirm == "") {
      print('請輸入學號及密碼！');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '請輸入學號及密碼！',
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('確定'),
              ),
            ],
            contentPadding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          );
        },
      );
    } else {
      if (password != passwordConfirm) {
        print('確認密碼有誤，請重新輸入！');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '確認密碼有誤，請重新輸入！',
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
              contentPadding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
      } else {
        String jsonData = jsonEncode(data);
        Map<String, String> headers = {
          'Content-Type': 'application/json',
        };

        // 發送登錄請求
        String Loginurl = ('${apiUrl}/Register');
        try {
          http.Response response = await http.post(Uri.parse(Loginurl),
              headers: headers, body: jsonData);
          print(jsonData);
          String responseData = response.body;
          var res = jsonDecode(responseData);
          var status = res['cause'];

          if (status == 0) {
            _showAlertDialog(context);
          } else if (status == 101) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: const SizedBox(
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '此學號已被註冊！',
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('確定'),
                    ),
                  ],
                  contentPadding:
                      const EdgeInsets.only(top: 40, right: 20, left: 20),
                );
              },
            );
            // 登錄失敗，處理失敗的邏輯
            print('登錄失敗：$responseData');
          }
        } catch (e) {
          // 异常处理
          print('api ERROR：$e');
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home/login.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.215),
                Center(
                  child: Container(
                    height: screenHeight * 0.6,
                    width: screenWidth * 0.78,
                    decoration: BoxDecoration(
                      color: const Color(0xe6fcf7f0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.05),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                '註冊',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    letterSpacing: 25),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          const SizedBox(
                            width: 170,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '請輸入您在東華大學的學號',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Container(
                            height: 35,
                            width: 200,
                            decoration: BoxDecoration(
                                color: const Color(0xffcab595),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.black)),
                            child: TextField(
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 2),
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                hintText: '學號',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    letterSpacing: 8),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 11.0, horizontal: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          const SizedBox(
                            width: 170,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '設定您的密碼，字數須6~12碼',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Container(
                            height: 35,
                            width: 200,
                            decoration: BoxDecoration(
                                color: const Color(0xffcab595),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.black)),
                            child: TextField(
                              controller: _passwordController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 2),
                              decoration: const InputDecoration(
                                hintText: '密碼',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    letterSpacing: 8),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 11.0, horizontal: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          Container(
                            height: 35,
                            width: 200,
                            decoration: BoxDecoration(
                                color: const Color(0xffcab595),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.black)),
                            child: TextField(
                              controller: _passwordConfirmController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  letterSpacing: 2),
                              decoration: const InputDecoration(
                                hintText: '確認密碼',
                                hintStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    letterSpacing: 8),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 11.0, horizontal: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                '已有帳號',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.0,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                },
                                child: const Text(
                                  '點擊登入',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Color(0xffda8970),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(width: 2, color: Colors.black),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xffe87d42)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: () {
                              _signin(apiUrl);
                            },
                            child: const SizedBox(
                              width: 60,
                              height: 25,
                              child: Center(
                                child: Text(
                                  '註冊',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.185),
              ],
            ),
          ),
        ));
  }
}
