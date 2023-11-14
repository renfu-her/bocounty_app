// import 'dart:math';

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'guild/guild.dart';
import 'home.dart';
import 'package:app/main.dart';

class RGuildPage extends StatefulWidget {
  const RGuildPage({super.key});

  @override
  _RGuildPageState createState() => _RGuildPageState();
}

class _RGuildPageState extends State<RGuildPage> {
  bool isChecked = true;
  final _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _month1Controller = TextEditingController();
  final TextEditingController _day1Controller = TextEditingController();
  final TextEditingController _month2Controller = TextEditingController();
  final TextEditingController _day2Controller = TextEditingController();
  final TextEditingController _hour2Controller = TextEditingController();
  final TextEditingController _bcoinController = TextEditingController();
  bool showImage = true;

  Timer? _timer;

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showImage = false;
        });
      }
    });
  }

  Future<void> _post(apiUrl) async {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    print('year：$currentYear');

    String tilte = _titleController.text;
    String content = _contentController.text;
    String month1 = _month1Controller.text;
    String day1 = _day1Controller.text;
    String month2 = _month2Controller.text;
    String day2 = _day2Controller.text;
    String hour2 = _hour2Controller.text;
    String bcoinText = _bcoinController.text;
    int? bcoin = int.tryParse(bcoinText);
    String execTime = "None";

    if (isChecked == false) {
      execTime = "$currentYear-$month2-$day2 $hour2:00:00";
    }

    // 構建登錄請求的資料
    Map<String, dynamic> data = {
      'title': tilte,
      'close_time': "$currentYear-$month1-$day1 23:59:59",
      'exec_time': execTime,
      'price': bcoin,
      'intro': content
    };

    String jsonData = jsonEncode(data);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    // 發送登錄請求
    String Posturl = ('$apiUrl:8000/createOrder');
    try {
      http.Response response =
          await http.post(Uri.parse(Posturl), headers: headers, body: jsonData);

      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      var id = data['id'];

      if (status == 0) {
        // 登錄成功，處理成功的邏輯
        print('創建成功：$responseData');
        print('委託ID:$id');
        await Future.delayed(const Duration(milliseconds: 300));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GuildPage()),
        );
      } else if (status == 205) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '輸入內容格式有誤，請檢查!',
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
        print('創建失敗：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '目前無法創建，請稍後在嘗試',
                ),
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
            contentPadding: const EdgeInsets.only(top: 40, right: 20, left: 20),
          );
        },
      );
    }
  }

  @override
  void initState() {
    print("ID:$User_Token");
    // _post(apiUrl);
    super.initState();
    _startTimer();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> _months = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12'
    ];
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String _selectedMonth = _months[0]; // 默认选择第一个月份

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/writeguild.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, top: 25),
                        height: screenHeight * 0.08,
                        width: screenHeight * 0.08,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const GuildPage()),
                              );
                              print('bakeButton click');
                            },
                            child: Image.asset('assets/images/back.png')),
                      ),
                    )),
                    Center(
                        child: Column(
                      children: [
                        Stack(
                          children: [
                            showImage
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.125,
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          height: screenHeight * 0.09,
                                          child: Image.asset(
                                            'assets/images/writeguilddialog.png',
                                            fit: BoxFit.contain,
                                          ))
                                    ],
                                  )
                                : Container(
                                    height: screenHeight * 0.09,
                                  )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                        Container(
                          height: screenHeight * 0.045,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xfff5eeda),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            style: const TextStyle(
                                color: const Color(0xff757575), fontSize: 12),
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: '標題',
                              hintStyle: TextStyle(
                                  color: const Color(0xff757575),
                                  fontSize: 12,
                                  letterSpacing: 5),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 13.5, horizontal: 12),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.008,
                        ),
                        Container(
                          // height: screenHeight*0.1,
                          child: Column(
                            children: [
                              Container(
                                height: screenHeight * 0.025,
                                child: Row(
                                  children: [
                                    Container(
                                      width: screenWidth * 0.27,
                                    ),
                                    Text(
                                      '募集時間 :  ~',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                          letterSpacing: 1),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.01,
                                    ),
                                    Container(
                                      height: screenHeight * 0.02,
                                      width: screenWidth * 0.055,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff5eeda),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: const Color(0xff757575),
                                            fontSize: 12),
                                        controller: _month1Controller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.005,
                                    ),
                                    Text(
                                      '月',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                          letterSpacing: 1),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.005,
                                    ),
                                    Container(
                                      height: screenHeight * 0.02,
                                      width: screenWidth * 0.055,
                                      decoration: BoxDecoration(
                                        color: const Color(0xfff5eeda),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            color: const Color(0xff757575),
                                            fontSize: 12),
                                        controller: _day1Controller,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.005,
                                    ),
                                    Text(
                                      '號',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12.0,
                                          letterSpacing: 1),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              Container(
                                  height: screenHeight * 0.025,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.27,
                                      ),
                                      Text(
                                        '任務時間 : ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                            letterSpacing: 1),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isChecked = true;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, left: 2),
                                            child: isChecked
                                                ? Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                    color: Colors.black,
                                                  )
                                                : Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                    color:
                                                        const Color(0xfff5eeda),
                                                  ),
                                          )),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Text(
                                        '無限制',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              Container(
                                  height: screenHeight * 0.025,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.27,
                                      ),
                                      Text(
                                        '任務時間 : ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xffE5D49B),
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                            letterSpacing: 1),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isChecked = false;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2, left: 2),
                                            child: isChecked
                                                ? Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                    color:
                                                        const Color(0xfff5eeda),
                                                  )
                                                : Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 10.0,
                                                        color: Colors.black,
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.01,
                                                      ),
                                                      Container(
                                                        height:
                                                            screenHeight * 0.02,
                                                        width:
                                                            screenWidth * 0.055,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xfff5eeda),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff757575),
                                                              fontSize: 12),
                                                          controller:
                                                              _month2Controller,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.005,
                                                      ),
                                                      Text(
                                                        '月',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.005,
                                                      ),
                                                      Container(
                                                        height:
                                                            screenHeight * 0.02,
                                                        width:
                                                            screenWidth * 0.055,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xfff5eeda),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff757575),
                                                              fontSize: 12),
                                                          controller:
                                                              _day2Controller,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.005,
                                                      ),
                                                      Text(
                                                        '號',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.005,
                                                      ),
                                                      Container(
                                                        height:
                                                            screenHeight * 0.02,
                                                        width:
                                                            screenWidth * 0.055,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xfff5eeda),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                        ),
                                                        child: TextField(
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff757575),
                                                              fontSize: 12),
                                                          controller:
                                                              _hour2Controller,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.005,
                                                      ),
                                                      Text(
                                                        '時',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1),
                                                      ),
                                                    ],
                                                  ),
                                          )),
                                    ],
                                  )),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                              Container(
                                  height: screenHeight * 0.025,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.27,
                                      ),
                                      Text(
                                        '報酬 :',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                            letterSpacing: 1),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.08,
                                      ),
                                      Container(
                                        height: screenHeight * 0.02,
                                        width: screenWidth * 0.085,
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff5eeda),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: TextField(
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: const Color(0xff757575),
                                              fontSize: 12),
                                          controller: _bcoinController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenWidth * 0.01,
                                      ),
                                      Text(
                                        'Bcoin',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: screenHeight * 0.008,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: screenHeight * 0.28,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xfff5eeda),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: TextField(
                            style: const TextStyle(
                                color: const Color(0xff757575), fontSize: 12),
                            controller: _contentController,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: '內容',
                              hintStyle: TextStyle(
                                  color: const Color(0xff757575),
                                  fontSize: 12,
                                  letterSpacing: 2),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(width: 2, color: Colors.black),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffe87d42)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            print(User_Token);
                            _post(apiUrl);
                          },
                          child: const SizedBox(
                            width: 60,
                            height: 25,
                            child: Center(
                              child: Text(
                                '發文',
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
                        SizedBox(height: screenHeight * 0.192),
                      ],
                    )),
                  ],
                ))
          ]),
        ));
  }
}
