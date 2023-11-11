import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/joinEntrust.dart';

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
                      // 在這裡添加導航邏輯
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                JoinEntrustDealPage()), // 替換為另一個目標頁面
                      );
                    },
                    child: Text('已參加委託', style: TextStyle(fontSize: 20)),
                  ),
                ),
                // 新增包含文字的閃動方塊
                // 新增包含文字的閃動方塊
                Positioned(
                  right: 0, // 水平居中
                  top: 60, // 垂直居中,
                  child: FadeTransition(
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ],
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
                              builder: (context) => const MailPage()),
                        );
                        print('backButton click');
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
