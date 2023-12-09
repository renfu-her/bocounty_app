import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/deal/clientWrite.dart';
import 'package:dio/dio.dart';
import 'package:app/main.dart';
import 'package:app/deal/caseInterest.dart';
import 'package:app/home.dart';
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

  void fetchData() async {
    var dio = Dio();
    var data = {
      'userToken': userToken,
    };
    try {
      var response =
          await dio.get('${laravelUrl}api/user/client/getAll', data: data);

      if (response.statusCode == 200) {
        setState(() {
          items = response.data['data'];
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
                MaterialPageRoute(builder: (context) => const HomePage()),
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
                alignment: Alignment.topCenter,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 45,
                  top: 70,
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
                            width: 140,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 310,
                  left: 70,
                  right: 70,
                  bottom: 82,
                  child: SingleChildScrollView(
                    child: Column(
                      children: items.map((item) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    InterestPage(itemId: item['id']),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center, // 將文字居中對齊於圖片
                            children: [
                              Image.asset(
                                'assets/images/icon/banner-want.png', // 圖片路徑
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
                              builder: (context) => const HomePage()),
                        );
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
