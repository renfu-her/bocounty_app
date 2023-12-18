import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/deal.dart';
import 'package:app/deal/dealType.dart';
import 'package:app/message/msgCase.dart';
import 'package:app/deal/joinEntrust.dart';

class JoinViewDetailPage extends StatefulWidget {
  final int itemId;
  const JoinViewDetailPage({super.key, required this.itemId});

  @override
  _JoinViewDetailPageState createState() => _JoinViewDetailPageState();
}

class _JoinViewDetailPageState extends State<JoinViewDetailPage>
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
  String? _caseId;
  String? _userId = '';
  String? _name = '';
  String? _mobile = '';
  String? _status = '';
  String? _join_id = '';

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

    try {
      var response =
          await dio.get('${laravelUrl}api/user/case-detail', data: data);

      if (response.statusCode == 200) {
        setState(() {
          items = [response.data['data']];
          if (items.isNotEmpty) {
            _titleController.text = items[0]['title'];
            _contentController.text = items[0]['content'];
            _name = items[0]['name'];
            _endDate = items[0]['end_date'];
            _pay = items[0]['pay']?.toString();
            _title = items[0]['title'];
            _caseId = items[0]['case_id']?.toString();
            _userId = items[0]['user_id'];
            _mobile = items[0]['mobile'];
            _status = items[0]['status'];
            _join_id = items[0]['join_id'];
          }
          // print(items.isNotEmpty);
          // items.map((item) => print(item['title']));
        });
      }
    } catch (e) {
      // 處理錯誤
      print('Error fetching data user/case-detail: $e');
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
                MaterialPageRoute(builder: (context) => const DealTypePage()),
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
                alignment: Alignment.topCenter,
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
                              builder: (context) =>
                                  const JoinEntrustDealPage()),
                        );
                      },
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                ),
                Positioned(
                  top: 225, // 根据需要调整位置
                  left: 105,
                  right: 105,
                  child: Column(
                    children: [
                      Container(
                        height: 35,
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
                        height: 16,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '${_endDate}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xff757575),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start, // 修改這裡
                          children: <Widget>[
                            Image.asset('assets/images/profile.png',
                                width: 80.0, height: 80.0),
                            const SizedBox(width: 10.0),
                            Text(
                              '${_name}\n募集時間：${_endDate}\n聯絡方式：${_mobile}\n報酬：${_pay}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 310,
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // 设置圆角的半径
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_status == '1') {
                            var dio = Dio();
                            var data = {
                              'userToken': userToken,
                              'itemId': _caseId,
                              "join_id": _join_id,
                              'status': "2"
                            };

                            var response = await dio.post(
                                '${laravelUrl}api/user/do-case',
                                data: data);

                            if (response.statusCode == 200) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const JoinEntrustDealPage()));
                            }
                          }
                        },
                        child: SizedBox(
                          width: 100,
                          height: 25,
                          child: Center(
                            child: Text(
                              _status == '0'
                                  ? '關閉'
                                  : (_status == '1' ? '已完成' : '關閉'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
