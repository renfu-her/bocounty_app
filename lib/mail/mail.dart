// import 'dart:math';

import 'package:app/notify.dart';
import 'package:flutter/material.dart';

import 'package:app/deal/deal.dart';
import 'package:app/home.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
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
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            isMenuOpen = true;
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
                        image: AssetImage('assets/images/mail/mail.png'),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
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
                        Center(
                            child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth * 0.6,
                              child: InkWell(
                                  onTap: () {
                                    if (isMenuOpen == true) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DealPage()),
                                      );
                                      print('deal click');
                                    } else {
                                      setState(() {
                                        isMenuOpen = true;
                                      });
                                    }
                                  },
                                  child: Image.asset(
                                      'assets/images/mail/deal.png')),
                            ),
                            SizedBox(
                              height: screenHeight * 1 / 2,
                            ),
                            // Container(
                            //   alignment: Alignment.center,
                            //   width: screenWidth*0.6,
                            //   child: InkWell(
                            //       onTap: () {
                            //         if(isMenuOpen==true){
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(builder: (context) => const NotifyPage()),
                            //           );
                            //           print('notify click');
                            //         }else{
                            //           setState(() {
                            //             isMenuOpen=true;
                            //           });
                            //         }
                            //       },
                            //       child: Image.asset('assets/images/mail/notify.png')
                            //   ),
                            // ),
                          ],
                        ))
                      ],
                    )),
              ],
            )));
  }
}
