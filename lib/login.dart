import 'dart:convert';

import 'package:app/setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/signin.dart';
import 'package:app/home.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _focusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _login(apiUrl) async {
    String username = _usernameController.text;
    String password = _passwordController.text;


    // 構建登錄請求的資料
    Map<String, String> data = {
      'student_id': username,
      'password': password,
    };

    String jsonData = jsonEncode(data);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };


    // 發送登錄請求
    String Loginurl = ('$apiUrl:8000/Login');
    try {
      http.Response response = await http.post(Uri.parse(Loginurl), headers: headers, body: jsonData);



      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      String? rawCookie = response.headers['set-cookie'];
      String cookie = "";
      if (rawCookie != null) {
        int index = rawCookie.indexOf(';');
        cookie = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      }
      int equalsIndex = cookie.indexOf('=');
      User_Token = cookie.substring(equalsIndex + 1);

      if (status == 0) {
        // 登錄成功，處理成功的邏輯
        print('登錄成功：$responseData');
        print('User_Token:$User_Token');
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else if(status == 205) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('請輸入正確的帳號密碼，或註冊帳號',),
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
              contentPadding: const EdgeInsets.only(top:40,right: 20,left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('登錄失敗：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
            const SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Text('請先從右上角的設定中設置ip地址，或檢查網路連線',),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('确定'),
              ),
            ],
            contentPadding: const EdgeInsets.only(top:40,right: 20,left: 20),
          );
        },
      );
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
      onTap: (){
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
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.only(right: 10,top: 35),
                      height: 70,
                      width: 70,
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingPage()),
                            );
                            print('setting click');
                          },
                          child: Image.asset('assets/images/setting.png')
                      ),
                    ),
                  )
              ),
              // SizedBox(height: screenHeight*0.115),
              Center(
                child: Container(
                  height: screenHeight*0.6,
                  width: screenWidth*0.78,
                  decoration: BoxDecoration(
                    color: const Color(0xe6fcf7f0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                  Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: screenHeight*0.06),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const Center(
                            child: Text(
                              '登入',
                              style: TextStyle(color: Colors.black, fontSize: 20,letterSpacing: 25),
                            ),
                          ),
                        ),SizedBox(height: screenHeight*0.06),
                        Container(
                          height: 35,
                          width: 200,
                          decoration: BoxDecoration(
                              color: const Color(0xffcab595),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white,fontSize: 13,letterSpacing: 2),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              hintText: '學號',
                              hintStyle: TextStyle(color: Colors.white,fontSize: 13,letterSpacing: 8),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 11.0,horizontal: 15),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight*0.05),
                        Container(
                          height: 35,
                          width: 200,
                          decoration: BoxDecoration(
                              color: const Color(0xffcab595),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          child: TextField(
                            style: const TextStyle(color: Colors.white,fontSize: 13,letterSpacing: 2),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              hintText: '密碼',
                              hintStyle: TextStyle(color: Colors.white,fontSize: 13,letterSpacing: 8),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 11.0,horizontal: 15),
                            ),
                          ),
                        ), SizedBox(height: screenHeight*0.005),
                        SizedBox(
                          width: 170,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(

                              onTap: () {
                                // 在这里添加点击事件处理程序
                                if (kDebugMode) {
                                  print('Text was clicked!');
                                }
                              },
                              child: const Text(
                                '忘記密碼',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color(0xffda8970),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.0,
                                ),
                              ),
                            ),
                          ),
                        ),SizedBox(height: screenHeight*0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              '尚無帳號',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 13.0,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const SignInPage()),
                                );
                              },
                              child: const Text(
                                '點擊註冊',
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
                      SizedBox(height: screenHeight*0.06),
                        TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(width: 2, color: Colors.black),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe87d42)),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            _login(apiUrl);
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 25,
                            child:
                            Center(
                              child: Text(
                                '登入',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.185),
            ],
          ),
        ),
      )
    );
  }
}
