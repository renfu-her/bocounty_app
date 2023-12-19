import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/joinEntrust.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/joinView.dart';
import 'package:app/deal/dealTypeOne.dart';
import 'package:app/deal/dealTypeTwo.dart';

class DealTypePage extends StatefulWidget {
  const DealTypePage({super.key});

  @override
  _DealTypePageState createState() => _DealTypePageState();
}

class _DealTypePageState extends State<DealTypePage>
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
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _animationController.dispose(); // 釋放AnimationController資源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double squareSize = screenWidth * 0.4;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(// 使用Stack来覆盖其他组件
            children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Column中内容垂直居中
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe0ac4e), // 背景色
                    onPrimary: Colors.white,
                    minimumSize: Size(squareSize, squareSize), // 设置按钮大小为正方形
                    // 文字色
                    side: BorderSide(width: 1, color: Colors.black), // 邊框
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 圓角邊框
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DealTypeOnePage()),
                    );
                  },
                  child: Text(
                    '已發佈委託',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                SizedBox(height: 20), // 两个按钮之间的间距
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFe0ac4e), // 背景色
                    onPrimary: Colors.white,
                    minimumSize: Size(squareSize, squareSize), // 设置按钮大小为正方形
                    // 文字色
                    side: BorderSide(width: 1, color: Colors.black), // 邊框
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 圓角邊框
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DealTypeTwoPage()),
                    );
                  },
                  child: Text(
                    '已參加委託',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topLeft, // 左上角定位
            child: Container(
              padding: const EdgeInsets.only(left: 25, top: 25), // 设置边距
              height: screenHeight * 0.08,
              width: screenHeight * 0.08,
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MailPage()),
                  );
                },
                child: Image.asset('assets/images/back.png'),
              ),
            ),
          ),
        ]));
  }
}
