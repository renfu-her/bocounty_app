import 'package:app/mail/mail.dart';
import 'package:app/deal/deal.dart';
import 'package:flutter/material.dart';
import 'package:app/home.dart';

class JoinEntrustDealPage extends StatefulWidget {
  const JoinEntrustDealPage({super.key});

  @override
  _JoinEntrustDealPageState createState() => _JoinEntrustDealPageState();
}

class _JoinEntrustDealPageState extends State<JoinEntrustDealPage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;

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
                MaterialPageRoute(builder: (context) => const MailPage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/bg02.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                // 第一個Text元件
                Positioned(
                  top: 220, // 可以根據需要調整這些值
                  left: 70,
                  child: GestureDetector(
                    onTap: () {
                      // 在這裡添加導航邏輯
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DealPage()), // 替換為另一個目標頁面
                      );
                    },
                    child: Text('已發佈委託', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const Positioned(
                  top: 220,
                  right: 70,
                  child: Text('已參加委託', style: TextStyle(fontSize: 20)),
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
