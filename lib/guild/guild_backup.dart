// import 'dart:math';

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home.dart';

import 'package:app/main.dart';
import '../writeguild.dart';

class GuildPage extends StatefulWidget {
  const GuildPage({super.key});

  @override
  _GuildPageState createState() => _GuildPageState();
}

class _GuildPageState extends State<GuildPage> {
  List<Map<String, dynamic>> postList = [];
  final _focusNode = FocusNode();

  String Close_time = "";
  String Exec_time = "";
  String Intro = "";
  String Owner_id = "";
  String Owner_name = "";
  String Start_time = "";
  String Title = "";

  bool showImage = true;
  bool isshowDialog = false;
  bool isLoading = false;
  String title = "";
  String id = "";
  String ID = "";

  Timer? _timer;

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showImage = false;
        });
      }
    });
  }

  Future<void> _getOpenOrder(apiUrl) async {
    DateTime now = DateTime.now();
    int currentYear = now.year;
    print('year：$currentYear');

    // String  tilte = _titleController.text;
    // String  content = _contentController.text;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    // 發送登錄請求
    String getOpenOrderurl = ('$apiUrl:8000/getOpenOrder');
    try {
      http.Response response =
          await http.get(Uri.parse(getOpenOrderurl), headers: headers);

      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      var list = data['list'];

      for (int i = 0; i < list.length; i++) {
        title = list[i]['title'] as String;
        id = list[i]['id'] as String;
        print("title:$title status:$id");
        Map<String, String> accessory = {
          'title': title,
          'id': id,
        };
        postList.add(accessory);
      }

// 标记加载完成
      isLoading = false;

      setState(() {
        // _getOpenOrder(apiUrl);
      });

      if (status == 0) {
        // 登錄成功，處理成功的邏輯
        print('取得資料成功：$responseData');
      } else if (status == 205) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '輸入內容格式有誤，請檢查!',
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
              contentPadding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('取得資料失敗：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');

      if (isshowDialog == false) {
        isshowDialog = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '目前取得資料失敗，請稍後在嘗試',
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('确定'),
                ),
              ],
              contentPadding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
      }
    }
  }

  Future<void> _getOrderInfo(apiUrl) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    // 發送登錄請求
    print(ID);
    String getOrderInfourl = ('$apiUrl:8000/getOrderInfo/$ID');
    try {
      http.Response response =
          await http.get(Uri.parse(getOrderInfourl), headers: headers);

      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      // String close_time = data['close_time'];
      // String exec_time = data['close_time'];
      // String intro = data['intro'];
      // String owner_id = data['owner_id'];
      // String owner_name = data['owner_name'];
      // String start_time = data['start_time'];
      String title2 = data['title'];
      // print(data);

// 标记加载完成
      isLoading = false;

      setState(() {
        // Close_time=close_time;
        // Exec_time=exec_time;
        // Intro=intro;
        // Owner_id=owner_id;
        // Owner_name=owner_name;
        // Start_time=start_time;
        Title = title2;
      });

      if (status == 0) {
        // 登錄成功，處理成功的邏輯
        print('取得資料成功：$responseData');
      } else if (status == 205) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '輸入內容格式有誤，請檢查!',
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('確定'),
                ),
              ],
              contentPadding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('取得資料失敗：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');

      if (isshowDialog == false) {
        isshowDialog = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '目前取得資料失敗，請稍後在嘗試',
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Text('确定'),
                ),
              ],
              contentPadding:
                  const EdgeInsets.only(top: 40, right: 20, left: 20),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getOpenOrder(apiUrl);

    Future.delayed(Duration.zero, () {
      _startTimer();
    });
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
    // _timer = Timer.periodic(Duration(seconds: 30), (timer) {
    //   // 在这里执行刷新页面的操作
    //   setState(() {
    //     _getOpenOrder(apiUrl);
    //   });
    // });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        child: Scaffold(
          body: Stack(children: [
            Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/guild.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: const EdgeInsets.only(left: 25, top: 25),
                        height: screenHeight * 0.08,
                        width: screenHeight * 0.08,
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
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
                        Stack(
                          children: [
                            showImage
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: screenWidth * 0.1,
                                      ),
                                      Container(
                                          alignment: Alignment.center,
                                          height: screenHeight * 0.13,
                                          child: Image.asset(
                                            'assets/images/guilddialog.png',
                                            fit: BoxFit.contain,
                                          ))
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showImage = false;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RGuildPage()),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.17,
                                        ),
                                        Container(
                                          alignment: Alignment.topCenter,
                                          height: screenHeight * 0.135,
                                          width: screenWidth * 0.4,
                                          child: Image.asset(
                                            'assets/images/guildbtn.png',
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.15,
                        ),
                        Container(
                            height: screenHeight * 0.52,
                            width: screenWidth * 0.7,
                            child: ListView.separated(
                              itemCount: postList.length,
                              separatorBuilder: (context, index) {
                                // 这里定义项之间的分隔符
                                return SizedBox(
                                    height: screenHeight *
                                        0.01); // 例如，这里设置垂直间距为16.0
                              },
                              itemBuilder: (context, index) {
                                // 这里根据API响应数据生成矩形按钮
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ID = postList[index]['id'];
                                      _getOrderInfo(apiUrl);
                                    });

                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => DetailPage(postList[index]['id']),
                                    //   ),
                                    // );
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(width: screenWidth * 0.05),
                                      Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.topCenter,
                                            // height: screenHeight * 0.1,
                                            width: screenWidth * 0.6,
                                            child: Image.asset(
                                              'assets/images/want.png',
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 25), // 左侧间距
                                                alignment: Alignment.centerLeft,
                                                height: screenHeight * 0.06,
                                                width: screenWidth * 0.4,
                                                child: Text(
                                                  postList[index]['title'],
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 20.0,
                                                      letterSpacing: 1),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                        SizedBox(
                          height: screenHeight * 0.1,
                        ),
                      ],
                    )),
                  ],
                ))
          ]),
        ));
  }
}

// class DetailPage extends StatefulWidget {
//   final String postId;
//   DetailPage(this.postId);
//
//   @override
//   _DetailPageState createState() => _DetailPageState();
// }
//
// class _DetailPageState extends State<DetailPage> {
//
//   // 在这里可以添加状态和交互逻辑
//   @override
//
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     // 在这里构建页面的UI
//     return GestureDetector(
//         onTap: (){
//           FocusScope.of(context).unfocus();
//           setState(() {
//
//           });
//         },
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body: Stack(
//               children: [
//                 Container(
//                     width: screenWidth,
//                     height: screenHeight,
//                     decoration: const BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage('assets/images/detail.png'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         Expanded(
//                             child: Align(
//                               alignment: Alignment.topLeft,
//                               child: Container(
//                                 padding: const EdgeInsets.only(left: 25,top: 25),
//                                 height: screenHeight*0.08,
//                                 width: screenHeight*0.08,
//                                 child: InkWell(
//                                     onTap: () {
//                                       Navigator.pop(
//                                         context,
//                                         MaterialPageRoute(builder: (context) => const GuildPage()),
//                                       );
//                                       print('bakeButton click');
//                                     },
//                                     child: Image.asset('assets/images/back.png')
//                                 ),
//                               ),
//                             )
//                         ),
//                         Center(
//                             child: Column(
//                               children: [
//
//                                 SizedBox(height: screenHeight*0.1,),
//                                 // Container(
//                                 //   height: screenHeight*0.045,
//                                 //   width: 200,
//                                 //   decoration: BoxDecoration(
//                                 //     color: const Color(0xfff5eeda),
//                                 //     borderRadius: BorderRadius.circular(18),
//                                 //   ),
//                                 //   child: Text(Title,
//                                 //     style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                 //
//                                 //   ),
//                                 // ),
//
//                                 SizedBox(height: screenHeight*0.008,),
//                                 Container(
//                                   // height: screenHeight*0.1,
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                         height: screenHeight*0.025,
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               width: screenWidth*0.27,
//                                             ),
//                                             Text(
//                                               '募集時間 :  ~',
//                                               textAlign: TextAlign.left,
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 12.0,
//                                                   letterSpacing: 1
//                                               ),
//                                             ),
//                                             SizedBox(width: screenWidth*0.01,),
//                                             Container(
//                                               height: screenHeight*0.02,
//                                               width: screenWidth*0.055
//
//
//                                               ,
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xfff5eeda),
//                                                 borderRadius: BorderRadius.circular(25),
//                                               ),
//                                               child:
//                                               TextField(
//                                                 textAlign: TextAlign.center,
//                                                 style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                 decoration: InputDecoration(
//                                                   border: InputBorder.none,
//                                                 ),
//                                               ),
//
//                                             ),
//                                             SizedBox(width: screenWidth*0.005,),
//                                             Text(
//                                               '月',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 12.0,
//                                                   letterSpacing: 1
//                                               ),
//                                             ),
//                                             SizedBox(width: screenWidth*0.005,),
//                                             Container(
//                                               height: screenHeight*0.02,
//                                               width: screenWidth*0.055,
//                                               decoration: BoxDecoration(
//                                                 color: const Color(0xfff5eeda),
//                                                 borderRadius: BorderRadius.circular(18),
//                                               ),
//                                               child: TextField(
//                                                 textAlign: TextAlign.center,
//                                                 style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                 decoration: InputDecoration(
//                                                   border: InputBorder.none,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(width: screenWidth*0.005,),
//                                             Text(
//                                               '號',
//                                               textAlign: TextAlign.center,
//                                               style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontWeight: FontWeight.normal,
//                                                   fontSize: 12.0,
//                                                   letterSpacing: 1
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       SizedBox(height: screenHeight*0.008,),
//                                       Container(
//                                           height: screenHeight*0.025,
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width: screenWidth*0.27,
//                                               ),
//                                               Text(
//                                                 '任務時間 : ',
//                                                 textAlign: TextAlign.left,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 1
//                                                 ),
//                                               ),
//
//                                               SizedBox(width: screenWidth*0.01,),
//                                               Text(
//                                                 '無限制',
//                                                 textAlign: TextAlign.left,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 1
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                       ),
//                                       SizedBox(height: screenHeight*0.008,),
//                                       Container(
//                                           height: screenHeight*0.025,
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width: screenWidth*0.27,
//                                               ),
//                                               Text(
//                                                 '任務時間 : ',
//                                                 textAlign: TextAlign.left,
//                                                 style: TextStyle(
//                                                     color: Color(0xffE5D49B),
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 1
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                   onTap: () {
//                                                     setState(() {
//
//                                                     });
//                                                   },
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(top: 2,left: 2),
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(Icons.circle,size: 10.0,color: Colors.black,),
//                                                         SizedBox(width: screenWidth*0.01,),
//                                                         Container(
//                                                           height: screenHeight*0.02,
//                                                           width: screenWidth*0.055,
//                                                           decoration: BoxDecoration(
//                                                             color: const Color(0xfff5eeda),
//                                                             borderRadius: BorderRadius.circular(25),
//                                                           ),
//                                                           child: TextField(
//                                                             textAlign: TextAlign.center,
//                                                             style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                             decoration: InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth*0.005,),
//                                                         Text(
//                                                           '月',
//                                                           textAlign: TextAlign.center,
//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight.normal,
//                                                               fontSize: 12.0,
//                                                               letterSpacing: 1
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth*0.005,),
//                                                         Container(
//                                                           height: screenHeight*0.02,
//                                                           width: screenWidth*0.055,
//                                                           decoration: BoxDecoration(
//                                                             color: const Color(0xfff5eeda),
//                                                             borderRadius: BorderRadius.circular(18),
//                                                           ),
//                                                           child: TextField(
//                                                             textAlign: TextAlign.center,
//                                                             style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                             decoration: InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth*0.005,),
//                                                         Text(
//                                                           '號',
//                                                           textAlign: TextAlign.center,
//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight.normal,
//                                                               fontSize: 12.0,
//                                                               letterSpacing: 1
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth*0.005,),
//                                                         Container(
//                                                           height: screenHeight*0.02,
//                                                           width: screenWidth*0.055,
//                                                           decoration: BoxDecoration(
//                                                             color: const Color(0xfff5eeda),
//                                                             borderRadius: BorderRadius.circular(18),
//                                                           ),
//                                                           child: TextField(
//                                                             textAlign: TextAlign.center,
//                                                             style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                             decoration: InputDecoration(
//                                                               border: InputBorder.none,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         SizedBox(width: screenWidth*0.005,),
//                                                         Text(
//                                                           '時',
//                                                           textAlign: TextAlign.center,
//                                                           style: TextStyle(
//                                                               color: Colors.black,
//                                                               fontWeight: FontWeight.normal,
//                                                               fontSize: 12.0,
//                                                               letterSpacing: 1
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     )
//                                                     ,
//                                                   )
//                                               ),
//                                             ],
//                                           )
//                                       ),
//                                       SizedBox(height: screenHeight*0.008,),
//                                       Container(
//                                           height: screenHeight*0.025,
//                                           child: Row(
//                                             children: [
//                                               Container(
//                                                 width: screenWidth*0.27,
//                                               ),
//                                               Text(
//                                                 '報酬 :',
//                                                 textAlign: TextAlign.left,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 1
//                                                 ),
//                                               ),
//                                               SizedBox(width: screenWidth*0.08,),
//                                               Container(
//                                                 height: screenHeight*0.02,
//                                                 width: screenWidth*0.085,
//                                                 decoration: BoxDecoration(
//                                                   color: const Color(0xfff5eeda),
//                                                   borderRadius: BorderRadius.circular(25),
//                                                 ),
//                                                 child: TextField(
//                                                   textAlign: TextAlign.center,
//                                                   style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                                   decoration: InputDecoration(
//                                                     border: InputBorder.none,
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: screenWidth*0.01,),
//                                               Text(
//                                                 'Bcoin',
//                                                 textAlign: TextAlign.center,
//                                                 style: TextStyle(
//                                                     color: Colors.black,
//                                                     fontWeight: FontWeight.normal,
//                                                     fontSize: 12.0,
//                                                     letterSpacing: 1
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                       ),
//                                       SizedBox(height: screenHeight*0.008,),
//                                     ],
//                                   ),
//                                 ),
//
//                                 Container(
//                                   height: screenHeight*0.28,
//                                   width: 200,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xfff5eeda),
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                   child: TextField(
//                                     style: const TextStyle(color: const Color(0xff757575),fontSize: 12),
//                                     maxLines: null,
//                                     decoration: const InputDecoration(
//                                       hintText: '內容',
//                                       hintStyle: TextStyle(color: const Color(0xff757575),fontSize: 12,letterSpacing: 2),
//                                       border: InputBorder.none,
//                                       contentPadding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight*0.02),
//                                 TextButton(
//                                   style: ButtonStyle(
//                                     side: MaterialStateProperty.all<BorderSide>(
//                                       const BorderSide(width: 2, color: Colors.black),
//                                     ),
//                                     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffe87d42)),
//                                     foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                                   ),
//                                   onPressed: () {
//                                     print(User_Token);
//                                   },
//                                   child: const SizedBox(
//                                     width: 60,
//                                     height: 25,
//                                     child:
//                                     Center(
//                                       child: Text(
//                                         '發文',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.normal,
//                                           fontSize: 15.0,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//
//                                 SizedBox(height: screenHeight*0.192),
//                               ],
//                             )
//                         ),
//                       ],
//                     )
//                 )
//               ]
//           ),
//         )
//     );
//   }
// }

