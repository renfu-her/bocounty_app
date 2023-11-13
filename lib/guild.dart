import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/clientWrite.dart';
// import 'package:app/deal/joinEntrust.dart';

class GuildPage extends StatefulWidget {
  const GuildPage({super.key});

  @override
  _GuildPageState createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage>
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
                image: AssetImage('assets/images/guild.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 80, // 水平居中
                  top: 60, // 垂直居中,
                  child: Container(
                    width: 190, // 方塊的寬度
                    margin: const EdgeInsets.all(20), // 方塊的邊距
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ClientWrite()),
                            );
                          },
                          child: Image.asset(
                            'assets/images/guildbtn.png',
                            fit: BoxFit.cover,
                            width: 120,
                          ),
                        ),
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
