// import 'dart:math';

import 'dart:async';
import 'package:app/card/card1.dart';
import 'package:app/card/card2.dart';
import 'package:app/card/cardinfo.dart';
import 'package:app/bonus/bonus.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

import 'home.dart';
import 'package:app/main.dart';
import 'package:dio/dio.dart';

var dio = Dio();

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _focusNode = FocusNode();
  bool isMenuOpen = false;
  bool showImage = true;
  late String card = "";
  String? userToken = User_Token;

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

  Future<void> _listPool(apiUrl) async {
    var headers = {
      'Cookie': 'user_token=$User_Token',
    };

    var response =
        await dio.get('$apiUrl/pool', options: Options(headers: headers));

    var data = response.data['data'];
    var message = response.data['message'];
    var status = message;
    pool_id = data[0]['id'].toString();
    debugPrint('pool_id: $pool_id');

    if (status == 'OK') {
      var pool = data[0];
      setState(() {
        card = apiUrl + pool['photo']!;
      });
      print("成功取得抽獎池! ,$data");
    } else {
      print('取得抽獎池錯誤：$message');
    }
  }

  Future<void> _getUserInfo(apiUrl) async {
    var headers = {
      'Cookie': 'user_token=$User_Token',
    };

    print('User Token: $User_Token');

    var response = await dio.get('$apiUrl/user/$student_id',
        options: Options(headers: headers));

    var data = response.data['data'];
    var message = response.data['message'];
    var status = message;

    if (status == 'OK') {
      var dataToken = {
        'userToken': User_Token,
      };
      var coins = await dio.get('${laravelUrl}api/user/coin', data: dataToken);

      var coinData = coins.data['data'];

      print(coinData);

      setState(() {
        bocoin = data['bocoin'] + coinData['coin'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    setState(() {
      bool isMenuOpen = false;
      _listPool(apiUrl);
      _getUserInfo(apiUrl);
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
          setState(() {
            isMenuOpen = false;
            _listPool(apiUrl);
            _getUserInfo(apiUrl);
          });
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/shop.png'),
                        fit: BoxFit.cover,
                        // alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Align(
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
                                        builder: (context) => const HomePage()),
                                  );
                                  print('bakeButton click');
                                },
                                child: Image.asset('assets/images/back.png')),
                          ),
                        )),
                        SizedBox(
                          // height: screenHeight*0.104,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end, // 水平方向对齐到行的末端
                            children: [
                              TextButton(
                                style: ButtonStyle(
                                  side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        width: 2, color: Colors.black),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          const Color(0xffdfb785)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15), // 圆角大小
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  await _getUserInfo(apiUrl);

                                  if (bocoin < 10) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('提示'),
                                          content: Text('您的 Bcoin 餘額不足。'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('關閉'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // 关闭对话框
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BonusPage()),
                                    );

                                    print('$bocoin coin');
                                  }
                                },
                                child: const SizedBox(
                                  width: 118,
                                  height: 40,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '兑换折抵券',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20), // 右边 20px 的空白
                            ],
                          ),
                        ),
                        Center(
                            child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: screenWidth * 0.52,
                                ),
                                Transform.rotate(
                                  angle: -0.5,
                                  child: Container(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CardInfoPage()),
                                          );
                                          print('CardInfo click');
                                        },
                                        child: SizedBox(
                                          // color: Colors.cyan,
                                          height: screenHeight * 0.06,
                                          width: screenHeight * 0.035,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isMenuOpen = !isMenuOpen;
                                    showImage = false;
                                  });
                                  print('confirm click');
                                },
                                child: Align(
                                  alignment: const Alignment(0.0045, 0),
                                  child: Transform.translate(
                                    offset: const Offset(0, 0.5),
                                    child: SizedBox(
                                        height: screenWidth * 0.475,
                                        width: screenWidth * 0.475,
                                        child: card.isNotEmpty
                                            ? Image.network(card)
                                            :
                                            // Container(
                                            //   height: screenHeight*0.1,
                                            //   width: screenHeight*0.1,
                                            //   child: Transform.scale(
                                            //     scale: 0.1, // 设置缩放比例，调整大小
                                            //     child: CircularProgressIndicator(
                                            //       strokeWidth: 40,
                                            //     ),
                                            //   ),
                                            // ),
                                            Container(
                                                child: const Center(
                                                  child: Text('正在抓取圖片...'),
                                                ),
                                              )),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.167,
                            ),
                            Stack(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    height: screenHeight * 0.2,
                                    child: showImage
                                        ? Image.asset(
                                            'assets/images/shopdialog.png',
                                            fit: BoxFit.contain,
                                          )
                                        : Container(
                                            height: screenHeight * 0.2,
                                          )),
                                Container(
                                    child: isMenuOpen
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // SizedBox(width: screenWidth*0.05,),
                                              Stack(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: screenHeight * 0.2,
                                                    child: Image.asset(
                                                      'assets/images/confirm.png',
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                  Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.08,
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          SizedBox(
                                                              width:
                                                                  screenWidth *
                                                                      0.30),
                                                          Container(
                                                            child: const Text(
                                                              '目前持有Bcoin數：',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xff050505),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 11.0,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              "$bocoin",
                                                              style:
                                                                  const TextStyle(
                                                                color: Color(
                                                                    0xffc09e5d),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 11.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            screenHeight * 0.03,
                                                      ),
                                                      Row(
                                                        // mainAxisAlignment: MainAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.255,
                                                          ),
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              side: MaterialStateProperty
                                                                  .all<
                                                                      BorderSide>(
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      const Color(
                                                                          0xff7A7186)),
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {
                                                              if (bocoin >=
                                                                  10) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const Card1Page()),
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          const SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            '您的bocoin不足！',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('確定'),
                                                                        ),
                                                                      ],
                                                                      contentPadding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              40,
                                                                          right:
                                                                              20,
                                                                          left:
                                                                              20),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child:
                                                                const SizedBox(
                                                              width: 36,
                                                              height: 18,
                                                              child: Center(
                                                                child: Text(
                                                                  '1抽',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    letterSpacing:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.1,
                                                          ),
                                                          TextButton(
                                                            style: ButtonStyle(
                                                              side: MaterialStateProperty
                                                                  .all<
                                                                      BorderSide>(
                                                                const BorderSide(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      const Color(
                                                                          0xff7A7186)),
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .white),
                                                            ),
                                                            onPressed: () {
                                                              if (bocoin >=
                                                                  90) {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              const Card2Page()),
                                                                );
                                                              } else {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return AlertDialog(
                                                                      content:
                                                                          const SizedBox(
                                                                        height:
                                                                            50,
                                                                        child:
                                                                            Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(
                                                                            '您的bocoin不足！',
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          child:
                                                                              const Text('確定'),
                                                                        ),
                                                                      ],
                                                                      contentPadding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              40,
                                                                          right:
                                                                              20,
                                                                          left:
                                                                              20),
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                            },
                                                            child:
                                                                const SizedBox(
                                                              width: 36,
                                                              height: 18,
                                                              child: Center(
                                                                child: Text(
                                                                  '10抽',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    letterSpacing:
                                                                        1,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          )
                                        : Column(
                                            children: [
                                              Container(
                                                height: screenHeight * 0.2,
                                              )
                                            ],
                                          )),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.069,
                            ),
                          ],
                        ))
                      ],
                    )),
              ],
            )));
  }
}
