import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/home.dart';
import 'package:app/shop.dart';
import 'package:app/bonus/bonusUse.dart';

var dio = Dio();

class BonusPage extends StatefulWidget {
  const BonusPage({super.key});

  @override
  _BonusHomePage createState() => _BonusHomePage();
}

class _BonusHomePage extends State<BonusPage> {
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
                            bonusId: coupons[index]['id'],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BonusUsePage(
                                      bonus_id: coupons[index]
                                          ['id']), // 使用 bonusId
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).viewInsets.bottom + 30, // 增加底部距離
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter, // 按钮对齐到右边
                    child: TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(width: 2, color: Colors.black),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffe87d42)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopPage(),
                          ),
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
  final VoidCallback? onPressed;
  final int bonusId;

  const CouponCard({
    Key? key,
    required this.iconData,
    required this.title,
    required this.subtitle,
    required this.expiryDate,
    this.onPressed,
    required this.bonusId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else {
          // 默認行為，如果沒有提供 onPressed
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BonusUsePage(bonus_id: bonusId), // 使用 bonusId
            ),
          );
        }
      }, // 使用 GestureDetector 來偵測點擊
      child: Card(
        elevation: 0, // 可以设置为0以移除卡片的阴影效果
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black, width: 1.0), // 添加黑色边框
          borderRadius: BorderRadius.circular(12.0), // 如果需要可以设置边框的圆角
        ),
        color: Color(0xFFcab595), // 卡片的背景颜色
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
