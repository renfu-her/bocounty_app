import 'dart:ffi';

import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/deal.dart';

class MsgJobViewDetailPage extends StatefulWidget {
  final String itemId;
  const MsgJobViewDetailPage({super.key, required this.itemId});

  @override
  _MsgJobViewDetailPageState createState() => _MsgJobViewDetailPageState();
}

class _MsgJobViewDetailPageState extends State<MsgJobViewDetailPage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  String? userToken = User_Token;
  List items = [];

  String? _name = '';
  String? _pay = '';
  String? _status = '';
  int? _case_id = 0;
  int? _join_id = 0;

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
    var data = {'userToken': userToken, 'itemId': widget.itemId};
    
    try {
      var response =
          await dio.post('${laravelUrl}api/user/case-to-confirm', data: data);

      if (response.statusCode == 200) {
        setState(() {
          items = [response.data['data']];
        });

        if (items.isNotEmpty) {
          _name = items[0]['name'];
          _pay = items[0]['pay'];
          _status = items[0]['status'];
          _case_id = items[0]['case_id'];
          _join_id = items[0]['join_id'];
        }
      } else {
        // 處理非200的響應
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
      backgroundColor: const Color(0xfff5eeda),
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
                MaterialPageRoute(builder: (context) => const DealPage()),
              );
            },
          ),
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background/running.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 320,
                  left: (screenWidth - 207) / 2,
                  child: Center(
                    child: Image.asset('assets/images/icon/block_confirm.png'),
                  ),
                ),
                Positioned(
                    top: 350,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset('assets/images/profile.png'),
                    )),
                const Positioned(
                  top: 465,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text('確定要委託', style: TextStyle(fontSize: 14)),
                  ),
                ),
                Positioned(
                  top: 490,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      '${_name}', // 使用 items 列表中的第一個元素的 name
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xffE87D42),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 530,
                  left: 0,
                  right: 0,
                  child: Center(
                    // 使用 Center 小部件
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // 这会使得 Row 中的内容居中
                      children: <Widget>[
                        Image.asset('assets/images/icon/coin.png'),
                        const SizedBox(width: 10.0), // 间距
                        Text('${_pay}'),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 280, // 距离底部的距离
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(width: 2, color: Colors.black),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffe0ac4e)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 设置圆角的半径
                          ),
                        ),
                      ),
                      onPressed: () async {
                        var dio = Dio();
                        var url = '${laravelUrl}api/user/set-status';
                        var data = {
                          'userToken': userToken,
                          'itemId': widget.itemId,
                          'join_id': _join_id.toString(),
                          'status': "1"
                        };

                        var response = await dio.post(url, data: data);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DealPage()),
                        );
                      },
                      child: const SizedBox(
                        width: 60,
                        height: 25,
                        child: Center(
                          child: Text(
                            '委託',
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
                  ),
                ),
                Positioned(
                  bottom: 170, // 距离底部的距离
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextButton(
                      style: ButtonStyle(
                        side: MaterialStateProperty.all<BorderSide>(
                          const BorderSide(width: 2, color: Colors.black),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xffE87D42)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // 设置圆角的半径
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DealPage()),
                        );
                      },
                      child: const SizedBox(
                        width: 60,
                        height: 25,
                        child: Center(
                          child: Text(
                            '關閉',
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
                              builder: (context) => const DealPage()),
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

class CaseItem {
  final int id;
  final String userId;
  final String title;
  final String content;
  final String startDate;
  final String endDate;
  final String mobile;
  final String pay;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String caseClientId;
  final String userJoinId;
  final String name;

  CaseItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.startDate,
    required this.endDate,
    required this.mobile,
    required this.pay,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.caseClientId,
    required this.userJoinId,
    required this.name,
  });

  factory CaseItem.fromJson(Map<String, dynamic> json) {
    return CaseItem(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      content: json['content'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      mobile: json['mobile'],
      pay: json['pay'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      caseClientId: json['case_client_id'],
      userJoinId: json['user_join_id'],
      name: json['name'],
    );
  }
}
