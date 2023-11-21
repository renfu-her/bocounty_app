import 'package:app/mail/mail.dart';
import 'package:app/deal/deal.dart';
import 'package:flutter/material.dart';
import 'package:app/main.dart';
import 'package:dio/dio.dart';
import 'package:app/deal/joinViewDetail.dart';

class JoinEntrustDealPage extends StatefulWidget {
  const JoinEntrustDealPage({super.key});

  @override
  _JoinEntrustDealPageState createState() => _JoinEntrustDealPageState();
}

class _JoinEntrustDealPageState extends State<JoinEntrustDealPage>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  String? userToken = User_Token;
  List<dynamic> items = [];

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

  @override
  void dispose() {
    _focusNode.dispose();
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
          print(items);
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
                      Navigator.pop(context, false);
                    },
                    child: const Text('已發佈委託', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const Positioned(
                  top: 220,
                  right: 70,
                  child: Text('已參加委託', style: TextStyle(fontSize: 20)),
                ),
                Positioned(
                  top: 300,
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
                            // print('Item status: ${item['status']}');
                            // 在這裡添加點擊事件邏輯
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      JoinViewDetailPage(itemId: item['id'])),
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
