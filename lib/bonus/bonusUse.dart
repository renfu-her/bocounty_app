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
  bool isLoading = true;
  String? userToken = User_Token;
  Map<String, dynamic>? bonusDetail;

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

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void fetchData() async {
    var dio = Dio();
    var data = {'userToken': userToken, 'bonus_id': widget.bonus_id};

    print(data);

    // print(data);
    try {
      var response = await dio.get('${laravelUrl}api/user/bonus', data: data);

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          bonusDetail = response.data['data'];
          isLoading = false;
          // print(items);
        });
      }
    } catch (e) {
      // 處理錯誤
      print('Error fetching data bonus/detail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var dio = Dio();
    var data = {'userToken': userToken, 'bonus_id': widget.bonus_id};

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
                        '確定要使用票券嗎？',
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
                      children: [
                        if (bonusDetail != null) ...[
                          Card(
                            elevation: 0, // 可以设置为0以移除卡片的阴影效果
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.black, width: 1.0), // 添加黑色边框
                              borderRadius:
                                  BorderRadius.circular(4.0), // 如果需要可以设置边框的圆角
                            ),
                            color: Color(0xFFcab595), // 卡片的背景颜色
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: Image.asset(bonusDetail!['icon'],
                                      width: 100, height: 100),
                                  title: Text(bonusDetail!['title']),
                                  subtitle: Text(bonusDetail!['sub_title']),
                                ),
                                Text('有效期至: ${bonusDetail!['expiry_date']}'),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFe0ac4e), // 背景色
                                    onPrimary: Colors.white, // 文字色
                                    side: BorderSide(
                                        width: 1, color: Colors.black), // 邊框
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(6), // 圓角邊框
                                    ),
                                  ),
                                  onPressed: () async {
                                    var res = await dio.post(
                                        '${laravelUrl}api/user/bonus',
                                        data: data);

                                    print(res.statusCode);

                                    if (res.statusCode == 200) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ShopPage()),
                                      );
                                    }
                                  },
                                  child: Text('使用優惠'),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFe87d42), // 背景色
                              onPrimary: Colors.white, // 文字色
                              side: BorderSide(
                                  width: 1, color: Colors.black), // 邊框
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6), // 圓角邊框
                              ),
                            ),
                            onPressed: () {
                              // 这里使用Navigator.of(context).pop()返回到上一个页面
                              Navigator.of(context).pop();
                            },
                            child: Text('關閉'),
                          ),
                        ] else ...[
                          Text('正在加載...'),
                        ],
                      ],
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
