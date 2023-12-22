// import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:app/shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app/main.dart';

class Card2Page extends StatefulWidget {
  const Card2Page({super.key});

  @override
  _Card2PageState createState() => _Card2PageState();
}

class _Card2PageState extends State<Card2Page> {
  final _focusNode = FocusNode();
  final bool _isLeftImageVisible = true;
  final List<dynamic> _displayedItems = [];
  late List<dynamic> _item = [];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _drawCards(apiUrl);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
    _startAnimation();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _drawCards(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'user_token=$User_Token',
    };
    Map<String, dynamic> data1 = {
      "type": 2,
    };

    String drawCardsurl = ('$apiUrl/pool/draw/$pool_id');
    try {
      String jsonData = jsonEncode(data1);
      http.Response response = await http.post(Uri.parse(drawCardsurl),
          headers: headers, body: jsonData);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['message'];
      final itemsList = data['data'];
      // final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(jsonDecode(itemsList));
      // final List<Item> item = items.map((itemData) => Item.fromJson(itemData)).toList();

      _item = [];
      if (status == "OK") {
        print(itemsList);
        setState(() {
          _item = itemsList;
          _startAnimation();
        });
        // print(_item[0]['photo']);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '取得資訊有誤請檢查網路或重啟應用程式',
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
        print('取得資訊錯誤 card2：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');
    }
  }

  void _startAnimation() {
    for (int i = 0; i < _item.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        setState(() {
          _displayedItems.add(_item[i]);
          _currentIndex = i;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 检查 _item 列表是否为空
    if (_item.isEmpty) {
      return const CircularProgressIndicator(); // 或者其他加载中的 UI 组件
    }

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
              image: AssetImage('assets/images/getCard.png'),
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
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: screenHeight * 0.065),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: screenWidth * 0.45,
                        height: screenHeight * 0.35,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 10.0),
                          scrollDirection: Axis.vertical,
                          itemCount: (_displayedItems.length / 2).ceil(),
                          itemBuilder: (context, rowIndex) {
                            final startIndex = rowIndex * 2;
                            final endIndex = startIndex + 2;
                            final itemsForRow = _displayedItems.sublist(
                                startIndex,
                                endIndex.clamp(0, _displayedItems.length));

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (_isLeftImageVisible)
                                  Column(
                                    children: [
                                      const SizedBox(height: 2.0),
                                      if (itemsForRow.isNotEmpty &&
                                          itemsForRow[0]['photo'] != null)
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff5eeda),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          width: screenWidth * 0.11,
                                          height: screenWidth * 0.11,
                                          child: Image.network(
                                            apiUrl + itemsForRow[0]['photo'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      const SizedBox(height: 12.0),
                                    ],
                                  ),
                                if (itemsForRow.length <= 1 ||
                                    itemsForRow[1]['photo'] == null)
                                  Column(
                                    children: [
                                      const SizedBox(height: 2.0),
                                      SizedBox(
                                        width: screenWidth * 0.11,
                                        height: screenWidth * 0.11,
                                      ),
                                      const SizedBox(height: 12.0),
                                    ],
                                  ),
                                if (itemsForRow.length > 1 &&
                                    itemsForRow[1]['photo'] != null)
                                  Column(
                                    children: [
                                      const SizedBox(height: 2.0),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        decoration: BoxDecoration(
                                          color: const Color(0xfff5eeda),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        width: screenWidth * 0.11,
                                        height: screenWidth * 0.11,
                                        child: Image.network(
                                          apiUrl + itemsForRow[1]['photo'],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 12.0),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(width: 2, color: Colors.black),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff7A7186)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ShopPage()),
                          );
                          print('close click');
                        },
                        child: const SizedBox(
                          width: 60,
                          height: 25,
                          child: Center(
                            child: Text(
                              '確認',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 5,
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
            ],
          ),
        ),
      ),
    );
  }
}

class Item {
  final int id;
  final String name;
  final String photo;

  Item({required this.id, required this.name, required this.photo});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int,
      name: json['name'] as String,
      photo: json['photo'] as String,
    );
  }
}

// ListView.builder(
//   padding: EdgeInsets.only(top: 10.0),
//   scrollDirection: Axis.vertical,
//   itemCount: (_item.length / 2).ceil(), // 每行显示两个图片，计算行数
//   itemBuilder: (context, rowIndex) {
//     final startIndex = rowIndex * 2;
//     final endIndex = startIndex + 2;
//     final itemsForRow = _item.sublist(startIndex, endIndex.clamp(0, _item.length));
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: itemsForRow.map((item) {
//         return Column(
//           children: [
//             SizedBox(height: 2.0), // 设置上方间距
//             Container(
//               decoration: BoxDecoration(
//                 color: Color(0xfff5eeda),
//                 borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
//               ),
//               width: screenWidth * 0.11,
//               height: screenWidth * 0.11,
//               child: Image.asset(
//                 item['photo'],
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             SizedBox(height: 12.0), // 设置下方间距
//           ],
//         );
//       }).toList(),
//     );
//   },
// ),