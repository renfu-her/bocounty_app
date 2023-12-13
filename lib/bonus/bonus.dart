import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/home.dart';
import 'package:app/shop.dart';

class BonusPage extends StatefulWidget {
  const BonusPage({super.key});

  @override
  _BonusHomePage createState() => _BonusHomePage();
}

class _BonusHomePage extends State<BonusPage> {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  final List<Map<String, dynamic>> coupons = [
    {
      'icon': 'assets/images/bonus/bonus-1.png',
      'title': '顔太煮奶茶-壽豐東華店',
      'subtitle': '加料仙草凍 兌換 * 1',
      'expiryDate': '2023/12/31',
    },
    {
      'icon': 'assets/images/bonus/bonus-1.png',
      'title': '顏太煮奶茶-壽豐東華店',
      'subtitle': '加料杏仁凍 兌換 * 1',
      'expiryDate': '2023/12/31',
    },
    {
      'icon': 'assets/images/bonus/bonus-2.png',
      'title': '田舍',
      'subtitle': "50＄內品項任選\n價格超過50＄自行補超額",
      'expiryDate': '2023/12/31',
    },
    {
      'icon': 'assets/images/bonus/bonus-3.png',
      'title': '燃 • 酒水龍頭室 SHOT兌換券',
      'subtitle': '低消一杯酒水即可兌換SHOT兩杯',
      'expiryDate': '2023/12/31',
    },
    // 可以添加更多的優惠券
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
                        '可兌換優惠券列表',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10), // 添加一點空間
                      Text(
                        '請在使用期限內兌換完畢，每張票券只可使用一次。',
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
                  child: Container(
                    child: ListView.builder(
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        return CouponCard(
                          iconData: coupons[index]['icon'],
                          title: coupons[index]['title'],
                          subtitle: coupons[index]['subtitle'],
                          expiryDate: coupons[index]['expiryDate'],
                        );
                      },
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
                              builder: (context) => const ShopPage()),
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

  const CouponCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.expiryDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
                          fontSize: 16, fontWeight: FontWeight.bold)),
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
    );
  }
}
