import 'dart:ffi';

import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/deal.dart';
import 'package:app/message/msgJobViewDetail.dart';

class MsgCasePage extends StatefulWidget {
  final String itemId;
  const MsgCasePage({super.key, required this.itemId});

  @override
  _MsgCasePageState createState() => _MsgCasePageState();
}

class _MsgCasePageState extends State<MsgCasePage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  String? userToken = User_Token;
  String? msg;
  List items = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });

    fetchData();
  }

  void fetchData() async {
    var dio = Dio();
    var data = {'userToken': userToken, 'itemId': widget.itemId};

    try {
      var response =
          await dio.post('${laravelUrl}api/user/join/getAll', data: data);

      if (response.statusCode == 200) {
        setState(() {
          msg = response.data['msg'];
          items = response.data['data'];
        });
      }
    } catch (e) {
      // 處理錯誤
      print('Error fetching data: $e');
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff5eeda),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                isMenuOpen = true;
              });
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DealPage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/running.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 230,
                  left: 80,
                  right: 80,
                  bottom: 180,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      ...items.map((item) {
                        return GestureDetector(
                          onTap: () {
                            if (msg == 'OK') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MsgJobViewDetailPage(
                                      itemId: item['case_client_id']),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center, // 將文字居中對齊於圖片
                            children: [
                              Image.asset(
                                'assets/images/icon/banner-list.png', // 圖片路徑
                                fit: BoxFit.cover,
                                width: 300,
                              ),
                              Positioned(
                                top: 0, // 調整為所需的位置
                                left: 20,
                                right: 0,
                                bottom: 20,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 50, // 調整容器的寬度
                                    height: 50, // 調整容器的高度
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/profile.png'), // 頭像圖片路徑
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 80, // 或者您希望的邊距大小
                                bottom: 45,
                                right: 60, // 根據需要調整
                                child: Text(
                                  item['name'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ]),
                  ),
                ),
                Positioned(
                  bottom: 170, // 距离底部的距离
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(width: 2, color: Colors.black),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffe0ac4e)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 设置圆角的半径
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DealPage()),
                        );
                      },
                      child: const SizedBox(
                        width: 100,
                        height: 25,
                        child: Center(
                          child: Text(
                            '關閉',
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
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    padding: const EdgeInsets.only(left: 25, top: 25),
                    height: screenHeight * 0.08,
                    width: screenHeight * 0.08,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DealPage()),
                        );
                      },
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
