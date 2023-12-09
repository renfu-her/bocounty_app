import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/joinEntrust.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/joinView.dart';

class DealPage extends StatefulWidget {
  const DealPage({super.key});

  @override
  _DealPageState createState() => _DealPageState();
}

class _DealPageState extends State<DealPage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? userToken = User_Token;
  List<dynamic> items = [];
  bool openImage = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });

    // 初始化AnimationController
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // 使動畫重複執行，並在每次迭代時反向

    // 創建Animation
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    fetchData();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose(); // 釋放AnimationController資源
    super.dispose();
  }

  void fetchData() async {
    var dio = Dio();
    var data = {
      'userToken': userToken,
    };

    // print(data);
    try {
      var response =
          await dio.post('${laravelUrl}api/user/client/view', data: data);

      // print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          items = response.data['data'];
          // print(items);
        });
      }
    } catch (e) {
      // 處理錯誤
      print('Error fetching data user/client/view: $e');
    }
  }

  void navigateAndDisplayImage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const JoinEntrustDealPage()),
    );

    // 更新圖片狀態
    if (result != null && !result) {
      setState(() {
        openImage = false;
      });
    }
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
                MaterialPageRoute(builder: (context) => const MailPage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/bg01.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: <Widget>[
                // 第一個Text元件
                const Positioned(
                  top: 220, // 可以根據需要調整這些值
                  left: 70,
                  child: Text('已發佈委託', style: TextStyle(fontSize: 20)),
                ),
                // 第二個Text元件
                Positioned(
                  top: 220,
                  right: 70,
                  child: GestureDetector(
                    onTap: () {
                      navigateAndDisplayImage();
                    },
                    child: Text('已參加委託', style: TextStyle(fontSize: 20)),
                  ),
                ),
                Positioned(
                  top: 300,
                  left: 70,
                  right: 70,
                  bottom: 82,
                  child: SingleChildScrollView(
                    child: Column(
                      children: items.map((item) {
                        String imagePath;
                        if (item['status'] == '1') {
                          imagePath = 'assets/images/icon/banner-running.png';
                        } else if (item['status'] == '2') {
                          imagePath = 'assets/images/icon/banner-finish.png';
                        } else {
                          imagePath = 'assets/images/icon/banner-want.png';
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JoinViewAllPage(itemId: item['id']),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center, // 將文字居中對齊於圖片
                            children: [
                              Image.asset(
                                imagePath, // 圖片路徑
                                fit: BoxFit.cover,
                                width: 300,
                              ),
                              Positioned(
                                left: 35, // 或者您希望的邊距大小
                                bottom: 35,
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
                Positioned(
                    right: 0,
                    top: 60,
                    child: openImage
                        ? FadeTransition(
                            opacity: _animation,
                            child: Container(
                              width: 190, // 方塊的寬度
                              height: 108, // 方塊的高度
                              margin: EdgeInsets.all(20), // 方塊的邊距
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/task/popup.png', // 圖片路徑
                                    fit: BoxFit.cover,
                                    width: 190,
                                    height: 108,
                                  ),
                                  const Positioned(
                                    left: 10,
                                    right: 10,
                                    top: 10,
                                    bottom: 10, // 文字與底部邊緣的距離
                                    child: Text(
                                      "Warmmy", // 您想顯示的文字
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    left: 10,
                                    right: 10,
                                    top: 25,
                                    bottom: 10, // 文字與底部邊緣的距離
                                    child: Text(
                                      "這裡可以看到你所有發布過的委託和接受過的委託，一起來豐富你的紀錄、豐富你的生活吧!", // 您想顯示的文字
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(
                            width: 190, // 方塊的寬度
                            height: 108, // 方塊的高度
                            margin: EdgeInsets.all(20), // 方塊的邊距
                            child: Stack(
                              children: [
                                Image.asset(
                                  'assets/images/task/popup.png', // 圖片路徑
                                  fit: BoxFit.cover,
                                  width: 190,
                                  height: 108,
                                ),
                                const Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 10,
                                  bottom: 10, // 文字與底部邊緣的距離
                                  child: Text(
                                    "Warmmy", // 您想顯示的文字
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  left: 10,
                                  right: 10,
                                  top: 25,
                                  bottom: 10, // 文字與底部邊緣的距離
                                  child: Text(
                                    "這裡可以看到你所有發布過的委託和接受過的委託，一起來豐富你的紀錄、豐富你的生活吧!", // 您想顯示的文字
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          )),
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
                              builder: (context) => const MailPage()),
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
