// import 'dart:math';


import 'package:app/mail.dart';
import 'package:flutter/material.dart';


class DealPage extends StatefulWidget {
  const DealPage({super.key});

  @override
  _DealPageState createState() => _DealPageState();
}

class _DealPageState extends State<DealPage> {
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

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
          setState(() {
            isMenuOpen = true;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MailPage()),
          );
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
                        image: AssetImage('assets/images/deal.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Column(
                      children: [

                      ],
                    )
                )
              ]
          ),
        )
    );
  }
}

