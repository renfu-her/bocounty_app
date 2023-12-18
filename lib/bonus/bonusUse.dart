import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/home.dart';
import 'package:app/shop.dart';
import 'package:app/bonus/bonus.dart';

var dio = Dio();

class BonusUsePage extends StatefulWidget {
  final int bonus_id;
  const BonusUsePage({super.key, required this.bonus_id});

  @override
  _BonusHomePage createState() => _BonusHomePage();
}

class _BonusHomePage extends State<BonusUsePage> {
  var headers = {
    'Cookie': 'user_token=$User_Token',
  };
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  final List<Map<String, dynamic>> coupons = [
    {
      'id': 1,
      'icon': 'assets/images/bonus/bonus-1.png',
      'title': '顔太煮奶茶-壽豐東華店',
      'subtitle': '加料仙草凍 兌換 * 1',
      'expiryDate': '2023/12/31',
    },
    {
      'id': 2,
      'icon': 'assets/images/bonus/bonus-1.png',
      'title': '顏太煮奶茶-壽豐東華店',
      'subtitle': '加料杏仁凍 兌換 * 1',
      'expiryDate': '2023/12/31',
    },
    {
      'id': 3,
      'icon': 'assets/images/bonus/bonus-2.png',
      'title': '田舍',
      'subtitle': "50＄內品項任選\n價格超過50＄自行補超額",
      'expiryDate': '2023/12/31',
    },
    {
      'id': 4,
      'icon': 'assets/images/bonus/bonus-3.png',
      'title': '燃 • 酒水龍頭室 SHOT兌換券',
      'subtitle': '低消一杯酒水即可兌換SHOT兩杯',
      'expiryDate': '2023/12/31',
    },
  ];

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
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(color: Color(0xfff5efe4)),
            child: Stack(
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 80),
                      Text(
                        '確定要使用票劵嗎？',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10), // 添加一點空間
                      Text(
                        '請將本頁面交給店家查看，並由店家協助操作!',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 160,
                  left: 30,
                  right: 30,
                  bottom: 82,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        coupons.length,
                        (index) {
                          return CouponCard(
                            iconData: coupons[index]['icon'],
                            title: coupons[index]['title'],
                            subtitle: coupons[index]['subtitle'],
                            expiryDate: coupons[index]['expiryDate'],
                            onPressed: () async {
                              var userVerify = await dio.get(
                                  '${apiUrl}/user/${student_id}',
                                  options: Options(headers: headers));
                              var userData = userVerify.data['data'];

                              print(headers);
                              print(student_id);
                              print(userData['id']);

                              var bonus_id = coupons[index]['id'];
                              var data = {
                                'userToken': User_Token,
                                'user_id': userData['id'],
                                'bonus_id': bonus_id,
                                'coins': 10
                              };

                              var userBonus = await dio.post(
                                  'https://demo.dev-laravel.co/api/user/bonus/save',
                                  data: data);
                            },
                          );
                        },
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
                              builder: (context) => const BonusPage()),
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

class CouponCard extends StatelessWidget {
  final String iconData;
  final String title;
  final String subtitle;
  final String expiryDate;
  final VoidCallback? onPressed;

  const CouponCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.expiryDate,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // 使用 GestureDetector 來偵測點擊
      child: Card(
        margin: const EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Image.asset(iconData, width: 100, height: 100),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(subtitle),
                    const SizedBox(height: 5),
                    Text('使用期限：$expiryDate'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
