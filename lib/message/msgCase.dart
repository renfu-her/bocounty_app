import 'dart:ffi';

import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/deal.dart';

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

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
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
      backgroundColor: Color(0xfff5eeda),
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
                  bottom: 100,
                  child: SingleChildScrollView(
                    child: Column(
                      children: items.map((item) {
                        return GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         JoinViewAllPage(itemId: item['id']),
                            //   ),
                            // );
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
                                left: 20, // 或者您希望的邊距大小
                                bottom: 25,
                                right: 60, // 根據需要調整
                                child: Text(
                                  item['title'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                        print('backButton click');
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
