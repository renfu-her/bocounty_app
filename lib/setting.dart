// import 'dart:math';

import 'package:flutter/material.dart';
import 'main.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _focusNode = FocusNode();
  final TextEditingController _apiController = TextEditingController();

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

  Future<void> _getIP() async {
    apiUrl = _apiController.text;
    print("ip:$apiUrl");
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
                SizedBox(height: screenHeight*0.215),
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
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: const Center(
                              child: Text(
                                'IP設定',
                                style: TextStyle(color: Colors.black, fontSize: 20,letterSpacing: 10),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.15),
                          const SizedBox(
                            width: 170,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '請輸入api的ip地址',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.005),
                          const SizedBox(
                            width: 170,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'ex:http://170.123.123.123',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10.0,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.015),
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
                              controller: _apiController,
                              decoration: const InputDecoration(
                                hintText: 'ip',
                                hintStyle: TextStyle(color: Colors.white,fontSize: 13,letterSpacing: 8),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.5,horizontal: 15),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight*0.15),
                          TextButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(width: 2, color: Colors.black),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe87d42)),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            ),
                            onPressed: () {
                              _getIP();
                              Navigator.pop(context);
                              print('back to login page');
                            },
                            child: const SizedBox(
                              width: 60,
                              height: 25,
                              child:
                              Center(
                                child: Text(
                                  '確認',
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
              ],
            ),
          ),
        )
    );
  }
}
