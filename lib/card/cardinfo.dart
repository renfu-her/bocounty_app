// import 'dart:math';

import 'dart:async';
import 'dart:convert';

import 'package:app/shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:app/main.dart';

class CardInfoPage extends StatefulWidget {
  const CardInfoPage({super.key});

  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardInfoPage> {
  final _focusNode = FocusNode();
  late List<dynamic> _item = [];

  @override
  void initState() {
    super.initState();
    _item = [];
    _getPoolItemList(apiUrl);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  Future<void> _getPoolItemList(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String getPoolItemListurl = ('$apiUrl/getPoolItemList/1');
    try {
      http.Response response =
          await http.get(Uri.parse(getPoolItemListurl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      final itemsList = data['items'];
      // final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(jsonDecode(itemsList));
      // final List<Item> item = items.map((itemData) => Item.fromJson(itemData)).toList();

      if (status == 0) {
        print(itemsList.length);
        setState(() {
          _item = itemsList;
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
        print('取得資訊錯誤 cardInfo：$responseData');
      }
    } catch (e) {
      // 异常处理
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
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/cardinfo.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: screenHeight * 0.215),
                Center(
                  child: Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.08,
                          ),
                          // Container(
                          //   color: Colors.cyan,
                          //   height: screenHeight*0.3,
                          //   width: screenWidth*0.5,
                          //   child: ListView(
                          //     children: [
                          //
                          //     ],
                          //   )
                          //   ,
                          // ),
                          SizedBox(
                            // color: Colors.cyan,
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.5,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 10.0),
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  (_item.length / 2).ceil(), // 每行显示两个图片，计算行数
                              itemBuilder: (context, rowIndex) {
                                final startIndex = rowIndex * 2;
                                final endIndex = startIndex + 2;
                                final itemsForRow = _item.sublist(startIndex,
                                    endIndex.clamp(0, _item.length));

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: itemsForRow.map((item) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 2.0), // 设置上方间距
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xfff5eeda),
                                            borderRadius: BorderRadius.circular(
                                                10.0), // 设置圆角半径
                                          ),
                                          width: screenWidth * 0.18,
                                          height: screenWidth * 0.18,
                                          child: Image.asset(
                                            item['photo'],
                                            fit: BoxFit.contain,
                                          ),
                                        ),

                                        const SizedBox(height: 10.0), // 设置下方间距
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          TextButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(width: 2, color: Colors.black),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xff7A7186)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
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
                                  '關閉',
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
                ),
              ],
            ),
          ),
        ));
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
