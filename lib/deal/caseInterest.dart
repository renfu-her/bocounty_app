import 'dart:ffi';

import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/guild/guild.dart';

class InterestPage extends StatefulWidget {
  final int itemId;
  const InterestPage({super.key, required this.itemId});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  String? userToken = User_Token;
  List items = [];

  TextEditingController _contentController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  String? _endDate = '';
  String? _pay = '';
  String? _title = '';

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

  void fetchData() async {
    var dio = Dio();
    var data = {
      'userToken': userToken,
      'itemId': widget.itemId,
    };

    print(data);
    try {
      var response =
          await dio.get('${laravelUrl}api/user/case-detail', data: data);

      print(response.statusCode);

      if (response.statusCode == 200) {
        setState(() {
          items = [response.data['data']];
          if (items.isNotEmpty) {
            _titleController.text = items[0]['title'];
            _contentController.text = items[0]['content'];
            _endDate = items[0]['end_date'];
            _pay = items[0]['pay'];
            _title = items[0]['title'];
          }
          // print(items.isNotEmpty);
          // items.map((item) => print(item['title']));
        });
      }
    } catch (e) {
      // 處理錯誤
      print('Error fetching data: $e');
    }
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
      backgroundColor: Color(0xfff5eeda),
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
                MaterialPageRoute(builder: (context) => const GuildPage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/interest.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
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
                              builder: (context) => const GuildPage()),
                        );
                        print('backButton click');
                      },
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 240, // 根据需要调整位置
                  left: 105,
                  right: 105,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${_title}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 200,
                        child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              '${_endDate}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff757575),
                                fontSize: 12,
                              ),
                            )),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 250,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xfff5eeda),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0), // 这里设置上下左右的间隔
                            child: Text(
                              _contentController.text,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(width: 2, color: Colors.black),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffe0ac4e)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () async {},
                        child: const SizedBox(
                          width: 100,
                          height: 25,
                          child: Center(
                            child: Text(
                              '我有興趣！',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
