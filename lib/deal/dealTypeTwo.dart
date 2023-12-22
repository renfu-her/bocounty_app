import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/joinEntrust.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/joinView.dart';
import 'package:app/deal/dealType.dart';
import 'package:app/deal/joinViewDetail.dart';

class DealTypeTwoPage extends StatefulWidget {
  const DealTypeTwoPage({super.key});

  @override
  _DealTypeTwoPageState createState() => _DealTypeTwoPageState();
}

class _DealTypeTwoPageState extends State<DealTypeTwoPage>
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
          await dio.post('${laravelUrl}api/user/join/view', data: data);

      // print(response.statusCode);

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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            child: Stack(
              children: <Widget>[
                // 第一個Text元件
                const SizedBox(
                  height: 200, // 指定高度
                  child: Center(
                    child: Text(
                      '已參加委託',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Positioned(
                  top: 150,
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
                                    JoinViewDetailPage(itemId: item['id']),
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
                              builder: (context) => const DealTypePage()),
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
