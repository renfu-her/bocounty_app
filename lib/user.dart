
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'edit.dart';
import 'main.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String username = "";
  String userintro = "";
  int userbocoin = 0;
  String cookie = "";
  String changeName = "";
  String changeIntro = "";

  late String _hair= "assets/images/item/hair/boy.png";
  late String _face= "assets/images/item/face/boy.png";
  late String _clothes= "assets/images/item/clothes/boy.png";
  late String _else= "assets/images/item/else/people.png";

  late TextEditingController _changeNameController = TextEditingController();
  late TextEditingController _changeIntroController = TextEditingController();
  late String changeCoin = "";

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();

  // late bool isears =false;
  bool isStackVisible = false;
  bool isEditingEnabled1 = false;
  bool isEditingEnabled2 = false;
  int count = 0;
  int check =0;

  final InputBorder _underlineBorder = const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  @override
  void initState() {
    _getUserInfo(apiUrl);
    _getUserOutlook(apiUrl);
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        isStackVisible = true;
      });
    });
  }

  Future<void> _getUserInfo(apiUrl) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String getUserInfourl = ('$apiUrl:8000/getUserInfo');
    try {
      http.Response response = await http.get(Uri.parse(getUserInfourl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      var name = data['name'];
      var intro = data['intro'];
      var bocoin = data['bocoin'];


      if (status == 0) {
        print('取得使用者資料：$responseData');
        username=name;
        userbocoin=bocoin;
        userintro=intro;
        if (check == 0){
          check == 1;
          setState(() {
            _changeNameController=TextEditingController(text: username);
            _changeIntroController=TextEditingController(text: userintro);
            changeCoin = userbocoin.toString();
          });
        }

      } else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('取得資訊有誤請檢查網路或重啟應用程式',),
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
              contentPadding: const EdgeInsets.only(top:40,right: 20,left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('取得資訊錯誤：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');
    }
  }

  Future<void> _getUserOutlook(apiUrl) async {

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String getUserOutlookurl = ('$apiUrl:8000/getUserOutlook');
    try {
      http.Response response = await http.get(Uri.parse(getUserOutlookurl), headers: headers);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];
      var list = data['list'];
      int getImg = 0;

      for(int i=0;i<list.length;i++){
        String photo = list[i]['photo'] as String;

        if (photo.isNotEmpty) {
          if(list[i]['type']==1){
            setState(() {
              _hair = photo;
              getImg++;
            });
          }else if(list[i]['type']==2){
            setState(() {
              _face = photo;
              getImg++;
            });
          }else if(list[i]['type']==3){
            setState(() {
              _clothes = photo;
              getImg++;
            });
          }else if(list[i]['type']==4){
            setState(() {
              _else = photo;
              getImg++;
            });
            List else_ = ["else_people","else_genie","else_beast","else_bird","else_sea"];
            for(int j=0;j<else_.length;j++){
              if(list[i]['name']==else_[j]){
                setState(() {
                  // isears = true;
                  print("這是耳朵!");
                });
              }
            }
          }
        }
      }

      if (status == 0) {
        print("成功取得外觀! ,$getImg");
        print(data);
      } else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('取得圖片有誤請檢查網路或重啟應用程式',),
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
              contentPadding: const EdgeInsets.only(top:40,right: 20,left: 20),
            );
          },
        );
        print('取得圖片錯誤：$responseData');
      }
    } catch (e) {
      print('api ERROR：$e');
    }
  }

  Future<void> _changeUserInfo(apiUrl) async {

    Map<String, String> data2 = {
      'name': changeName,
      'intro': changeIntro,
    };

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Cookie': 'User_Token=$User_Token',
    };

    String changeUserInfourl = ('$apiUrl:8000/changeUserInfo');
    try {
      String jsonData = jsonEncode(data2);
      http.Response response = await http.post(Uri.parse(changeUserInfourl), headers: headers,body: jsonData);
      String responseData = response.body;
      var data = jsonDecode(responseData);
      var status = data['status'];


      if (status == 0) {
        print('更新資料成功');
      } else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content:
              const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text('更新資訊有誤請檢查網路或重啟應用程式',),
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
              contentPadding: const EdgeInsets.only(top:40,right: 20,left: 20),
            );
          },
        );
        // 登錄失敗，處理失敗的邏輯
        print('取得資訊錯誤：$responseData');
      }
    } catch (e) {
      // 异常处理
      print('api ERROR：$e');
    }
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // final TextEditingController _changeNameController = TextEditingController(text: username);
    // final TextEditingController _changeIntroController = TextEditingController(text: userintro);

    changeName = _changeNameController.text;
    changeIntro = _changeIntroController.text;

    return GestureDetector(
        onTap: (){
          _focusNode1.requestFocus();
          _focusNode1.unfocus();
          _focusNode2.requestFocus();
          _focusNode2.unfocus();
          setState(() {
            changeName = _changeNameController.text;
            changeIntro = _changeIntroController.text;
            print(changeName);
            print(changeIntro);
            _changeUserInfo(apiUrl);
            count = 0;
            isEditingEnabled1 = false;
            isEditingEnabled2 = false;
          });
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/user/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.only(left: 25,top: 25),
                          height: screenHeight*0.08,
                          width: screenHeight*0.08,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                print('bakeButton click');
                              },
                              child: Image.asset('assets/images/back.png')
                          ),
                        ),
                      )
                  ),
                  Center(
                    child:
                    Column(
                      children: <Widget>[
                        // SizedBox(height: screenHeight*0.3,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: screenWidth*0.01,),
                            Transform.rotate(
                              angle: 0.02,
                              // child: SizedBox(
                              child:SizedBox(
                                height: screenHeight*0.24,
                                width: screenWidth*0.5,
                                child: InkWell(
                                    onTap: () {
                                      // 當用戶點擊圖片按鈕時，執行一些操作
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => const EditPage()),
                                      );
                                      print('person click');
                                    },
                                  child: Center(
                                    child: isStackVisible ? Stack(
                                      children: [
                                        // Image.asset('assets/images/user/back.png'),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: screenWidth*0.35,
                                                child: FractionalTranslation(
                                                  translation: const Offset(0.12, 0.035),
                                                  child: Image.asset('assets/images/item/body.png'),
                                              )
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: screenWidth*0.35,
                                                child: FractionalTranslation(
                                                  translation: const Offset(0.12, 0.035),
                                                  child: Image?.asset(_face),
                                                )
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: screenWidth*0.35,
                                                child: FractionalTranslation(
                                                  translation: const Offset(0.12, 0.035),
                                                  child: Image.asset(_hair),
                                                )
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: screenWidth*0.35,
                                                child: FractionalTranslation(
                                                  translation: const Offset(0.12, 0.035),
                                                  child: Image.asset(_clothes),
                                                )
                                            )
                                        ),
                                        Align(
                                            alignment: Alignment.center,
                                            child: SizedBox(
                                                width: screenWidth*0.35,
                                                // child:Align(
                                                //   alignment: isears ? Alignment(0.0155, 0.04) : Alignment(0.3,0.27),
                                                child: FractionalTranslation(
                                                  // translation: isears ? const Offset(0.0155, 0.04) : const Offset(0.01,0.25),
                                                  translation: const Offset(0.12, 0.035),
                                                  child: Image.asset(_else),
                                                )
                                            )
                                        ),
                                      ],
                                    ): Image.asset('assets/images/user/back.png'),
                                  )
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth*0.06,)
                          ],
                        ),
                        Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: screenWidth*0.25),
                                SizedBox(height: screenHeight*0.1),
                                Expanded(
                                  child: Column(
                                  children: <Widget>[
                                    SizedBox(height: screenHeight*0.022),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.transparent),
                                      ),
                                      child: Transform.rotate(
                                        angle: -0.002,
                                        child:
                                        TextFormField(
                                          textAlign: TextAlign.center,
                                          controller: _changeNameController,
                                          enabled: isEditingEnabled1,
                                          focusNode: _focusNode1,
                                          textInputAction: TextInputAction.done,
                                          decoration: InputDecoration(
                                            border: isEditingEnabled1 ? _underlineBorder : InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff826843),
                                            letterSpacing: 1.5,
                                          ),
                                          onFieldSubmitted: (text){
                                            setState(() {
                                              changeName = _changeNameController.text;
                                              changeIntro = _changeIntroController.text;
                                              print(changeName);
                                              print(changeIntro);
                                              _changeUserInfo(apiUrl);
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              ),
                                Transform.rotate(
                                    angle: 0.01,
                                    child: Column(
                                      children: [
                                        SizedBox(height: screenHeight*0.02),
                                        SizedBox(
                                          height: 25,
                                          child:InkWell(
                                            // focusNode: _focusNode,
                                              onTap: () {
                                                if (count == 0){
                                                  setState(() {
                                                    count = 1;
                                                    isEditingEnabled1 = true;
                                                    _requestKeyboard1(context);
                                                    // FocusScope.of(context).requestFocus(_focusNode);
                                                  });
                                                }else if (count == 1){
                                                  setState(() {
                                                    count = 0;
                                                    isEditingEnabled1 = false;
                                                    print("change:${_changeNameController.text}");
                                                    // changeName=_changeNameController.text;
                                                    // changeIntro=userintro;
                                                  });
                                                  if (_focusNode1.hasFocus) {
                                                    // 如果焦点在文本输入框上，隐藏键盘
                                                    _focusNode1.unfocus();
                                                  }
                                                }
                                                print('edit click');
                                              },
                                              child: Image.asset('assets/images/user/edit.png')
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(width: screenWidth*0.32,),
                              ],
                            ),
                          )
                        ),
                        Center(
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(width: screenWidth*0.35),
                                  const SizedBox(width: 5),
                                  Transform.rotate(
                                    angle: 0.05,
                                    child: SizedBox(
                                      height: screenHeight*0.022,
                                      child: Image.asset('assets/images/user/coin.png'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                        children: <Widget>[
                                          SizedBox(height: screenHeight*0.004),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.transparent),
                                            ),
                                            child: Transform.rotate(
                                              angle: -0.01,
                                              child:Text(changeCoin)
                                            ),
                                          )
                                        ]
                                    ),
                                  ),
                                  SizedBox(width: screenWidth*0.35,),
                                ],
                              ),
                            )
                        ),
                        SizedBox(
                          height: screenHeight*0.0245,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(width: screenWidth*0.2,),
                            Transform.rotate(
                              angle: -0.01,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffc09e5d),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                width: screenWidth*0.55,
                                height: screenHeight*0.14,
                                child: InkWell(
                                  // focusNode: _focusNode,
                                  onTap: () {
                                    if (count == 0){
                                      setState(() {
                                        count = 1;
                                        isEditingEnabled2 = true;
                                        _requestKeyboard2(context);
                                        // FocusScope.of(context).requestFocus(_focusNode);
                                      });
                                    }else if (count == 1){
                                      // changeName=_changeNameController.text;
                                      // changeIntro=userintro;
                                      setState(() {
                                        count = 0;
                                        isEditingEnabled2 = false;
                                      });
                                      if (_focusNode2.hasFocus) {
                                        // 如果焦点在文本输入框上，隐藏键盘
                                        _focusNode2.unfocus();
                                      }
                                    }
                                    print('edit click');
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10,right: 10),
                                    child: TextFormField(
                                      textAlign: TextAlign.left,
                                      controller: _changeIntroController,
                                      enabled: isEditingEnabled2,
                                      focusNode: _focusNode2,
                                      textInputAction: TextInputAction.done,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff826843),
                                        letterSpacing: 1.5,
                                      ),
                                      onFieldSubmitted: (text){
                                        setState(() {
                                          changeName = _changeNameController.text;
                                          changeIntro = _changeIntroController.text;
                                          print(changeName);
                                          print(changeIntro);
                                          _changeUserInfo(apiUrl);
                                        });
                                      },
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight*0.16,
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
        )
    );
  }
  void _requestKeyboard1(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode1);
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }
  void _requestKeyboard2(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    Future.delayed(const Duration(milliseconds: 100), () {
      FocusScope.of(context).requestFocus(_focusNode2);
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }
}
