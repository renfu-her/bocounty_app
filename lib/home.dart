// import 'dart:math';

import 'dart:convert';

import 'package:app/guild/guild.dart';
import 'package:app/shop.dart';
import 'package:flutter/material.dart';
import 'package:app/user.dart';
import 'package:http/http.dart' as http;

import 'login.dart';
import 'mail/mail.dart';
import 'package:app/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;

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

  Future<void> _logoff(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String logoffurl = ('$apiUrl:8000/Logoff');
    try {
      http.Response response =
          await http.post(Uri.parse(logoffurl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];

      if (status == 0) {
        print('已登出!');
      } else {
        print('登出錯誤：$responseData');
      }
    } catch (e) {
      print('api ERROR：$e');
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
          setState(() {
            isMenuOpen = true;
          });
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: const BoxDecoration(color: Color(0xffF0E7D3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.only(right: 25, top: 25),
                            height: screenHeight * 0.075,
                            width: screenHeight * 0.075,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isMenuOpen = !isMenuOpen;
                                  });
                                  // 當用戶點擊圖片按鈕時，執行一些操作
                                  print('burger click');
                                },
                                child: Image.asset(
                                    'assets/images/home/burger.png')),
                          ),
                        )),
                        Center(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth * 0.8,
                              child: InkWell(
                                  onTap: () {
                                    if (isMenuOpen == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserPage()),
                                      );
                                      print('user click');
                                    } else {
                                      setState(() {
                                        isMenuOpen = true;
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                      'assets/images/home/user.png')),
                            ),
                            SizedBox(
                              height: screenWidth * 0.04,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.38,
                                    child: InkWell(
                                        onTap: () {
                                          if (isMenuOpen == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MailPage()),
                                            );
                                            print('mail click');
                                          } else {
                                            setState(() {
                                              isMenuOpen = true;
                                            });
                                          }
                                        },
                                        child: Image.asset(
                                            'assets/images/home/mail.png')),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.04,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: screenWidth * 0.38,
                                    child: InkWell(
                                        onTap: () {
                                          if (isMenuOpen == true) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ShopPage()),
                                            );
                                            print('shop click');
                                          } else {
                                            setState(() {
                                              isMenuOpen = true;
                                            });
                                          }
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Image.asset(
                                            'assets/images/home/shop.png')),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: screenWidth * 0.015,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth * 0.8,
                              child: InkWell(
                                  onTap: () {
                                    if (isMenuOpen == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GuildPage()),
                                      );
                                      print('guild click');
                                    } else {
                                      setState(() {
                                        isMenuOpen = true;
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                      'assets/images/home/guild.png')),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            ),
                          ],
                        ))
                      ],
                    )),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.translationValues(
                    isMenuOpen ? -200.0 : 0.0,
                    0.0,
                    0.0,
                  ),
                  child: Container(
                    width: 200,
                    height: screenHeight,
                    color: const Color(0xFFAB8E68),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.1,
                          ),
                          GestureDetector(
                              onTap: () {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => LoginPage()),
                                // );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 200,
                                child: const Text(
                                  '關於我們',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    letterSpacing: 5,
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          GestureDetector(
                              onTap: () {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => LoginPage()),
                                // );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 200,
                                child: const Text(
                                  '聯絡我們',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    letterSpacing: 5,
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: screenHeight * 0.2,
                          ),
                          GestureDetector(
                              onTap: () async {
                                _logoff(apiUrl);
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 200,
                                child: const Text(
                                  '登出',
                                  style: TextStyle(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    letterSpacing: 5,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
