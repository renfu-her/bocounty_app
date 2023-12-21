import 'dart:convert';
import 'package:app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/main.dart';

import 'package:dio/dio.dart';

var dio = Dio();

bool isStackVisible = false;
// bool isears =false;
String _hair = "assets/images/item/hair/boy.png";
String _face = "assets/images/item/face/boy.png";
String _clothes = "assets/images/item/clothes/boy.png";
String _else = "assets/images/item/else/people.png";
String _hairPID = "1";
String _facePID = "9";
String _clothesPID = "15";
String _elsePID = "21";
String _hairID = "1";
String _faceID = "9";
String _clothesID = "15";
String _elseID = "21";

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  List<String> categories = ['五官', '衣服', '髮型', '配件'];
  int selectedCategoryIndex = 0;

  List<Map<String, String>> hairAccessories = [];
  List<Map<String, String>> faceAccessories = [];
  List<Map<String, String>> clothesAccessories = [];
  List<Map<String, String>> otherAccessories = [];

  List<Map<String, String>> selectedAccessories = [];

  @override
  void initState() {
    _getUserOutlook(apiUrl);
    _getUserItem(apiUrl);
    setState(() {
      getCategoryAccessories();
    });
    super.initState();

    Future.delayed(const Duration(milliseconds: 250), () {
      setState(() {
        isStackVisible = true;
      });
    });
  }

  Future<void> _getUserOutlook(apiUrl) async {
    var headers = {
      'Cookie': 'user_token=$User_Token',
    };

    var itemWear = await dio.get('$apiUrl/item/wear/$student_id',
        options: Options(headers: headers));
    var itemWearData = itemWear.data['data'];

    try {
      var status = itemWear.data['message'];
      var list = itemWearData;
      int getImg = 0;

      for (int i = 0; i < list.length; i++) {
        String photo = list[i]['photo'] as String;

        if (photo.isNotEmpty) {
          if (list[i]['type'] == 1) {
            setState(() {
              _clothes = apiUrl + photo;
              getImg++;
            });
          } else if (list[i]['type'] == 2) {
            setState(() {
              _face = apiUrl + photo;
              getImg++;
            });
          } else if (list[i]['type'] == 3) {
            setState(() {
              _hair = apiUrl + photo;
              getImg++;
            });
          } else if (list[i]['type'] == 4) {
            setState(() {
              _else = apiUrl + photo;
              getImg++;
            });
            List else_ = [
              "else_people",
              "else_genie",
              "else_beast",
              "else_bird",
              "else_sea"
            ];
            for (int j = 0; j < else_.length; j++) {
              if (list[i]['name'] == else_[j]) {
                setState(() {
                  // isears = true;
                  print("這是耳朵!");
                });
              }
            }
          }
        }
      }

      if (status == "OK") {
        print("成功取得外觀! ,$getImg");
        print(list);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '取得圖片有誤請檢查網路或重啟應用程式',
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
        print('取得圖片錯誤：${itemWear.statusCode}');
      }
    } catch (e) {
      print('api _getUserOutlook ERROR：$e');
    }
  }

  Future<void> _getUserItem(apiUrl) async {
    var headers = {
      'Cookie': 'user_token=$User_Token',
    };
    var itemOwn =
        await dio.get('$apiUrl/item/own', options: Options(headers: headers));
    var itemOwnData = itemOwn.data['data'];

    try {
      var status = itemOwn.data['message'];
      var list = itemOwnData;

      for (int i = 0; i < list.length; i++) {
        print("123333" + list[i]['photo']);
        String photo = list[i]['photo'] as String;
        int type = list[i]['type'] as int;

        if (photo.isNotEmpty) {
          Map<String, String> accessory = {
            'item_id': list[i]['id'],
            'photo': apiUrl + photo,
          };

          switch (type) {
            case 1:
              clothesAccessories.add(accessory);
              break;
            case 3:
              hairAccessories.add(accessory);
              break;
            case 2:
              faceAccessories.add(accessory);
              break;
            case 4:
              otherAccessories.add(accessory);
              break;
            default:
              // Handle unrecognized type or ignore
              break;
          }
        }
      }

      if (status == 'OK') {
        print("成功取得物品!");
        print(list);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '取得物品有誤請檢查網路或重啟應用程式',
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
        print('取得物品錯誤：${itemOwn.statusCode}');
      }
    } catch (e) {
      print('api _getUserItem ERROR：$e');
    }
  }

  Future<void> _changeItem(
      apiUrl, hair, face, clothes, el, phair, pface, pclothes, pel) async {
    // 構建登錄請求的資料

    var headers = {
      'Cookie': 'user_token=$User_Token',
    };

    List<Map<String, dynamic>> updateList = [];

    // 只有當 hair 不是 1 時，才添加到 update_list
    if (hair != '1' && hair != '9' && hair != '15') {
      updateList.add({'item_id': hair, 'action': 2});
    }

    // 只有當 face 不是 1 時，才添加到 update_list
    if (face != '1' && face != '9' && face != '15') {
      updateList.add({'item_id': face, 'action': 2});
    }

    // 只有當 clothes 不是 1 時，才添加到 update_list
    if (clothes != '1' && clothes != '9' && clothes != '15') {
      updateList.add({'item_id': clothes, 'action': 2});
    }

    // 其他
    if (el != '1' && el != '9' && el != '15' && el != '21') {
      updateList.add({'item_id': el, 'action': 2});
    }

    var data = {'update_list': updateList};

    print(data.toString());

    var itemWear = await dio.request('$apiUrl/item/wear',
        data: data, options: Options(headers: headers, method: "PUT"));
    var itemWearData = itemWear;

    print('$apiUrl/item/wear');

    try {
      var res = itemWearData;
      var status = itemWearData.data['message'];

      if (status == "OK") {
        print(context);
      } else if (status == 101) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const SizedBox(
                height: 50,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    '更換失敗，請重試！',
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
        print('換裝失敗：${itemWear.statusCode}');
      }
    } catch (e) {
      // 异常处理
      print('_changeItem ERROR：$e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget loadImage(String imagePath) {
    if (imagePath.startsWith('asset')) {
      return Image.asset(imagePath);
    } else if (imagePath.startsWith('http')) {
      return Image.network(imagePath);
    } else {
      // 如果路徑不符合上述兩種情況，可以返回一個默認圖像或錯誤處理
      return Image.asset('assets/images/default.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // super.initState();
        getCategoryAccessories();
        setState(() {
          getCategoryAccessories();
        });
      },
      child: Scaffold(
          body: Stack(children: [
        Image.asset(
          'assets/images/item/edit.png',
          width: screenWidth,
          height: screenHeight,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserPage()),
                      );
                      print('bakeButton click');
                    },
                    child: Image.asset('assets/images/back.png')),
              ),
            )),
            SizedBox(
              height: screenHeight * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Transform.rotate(
                    angle: 0,
                    child: SizedBox(
                        width: screenWidth * 0.55,
                        child: Center(
                          child: isStackVisible
                              ? Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: screenWidth * 0.482,
                                            child: FractionalTranslation(
                                              translation:
                                                  const Offset(0.025, 0),
                                              child: Image.asset(
                                                  'assets/images/item/body.png'),
                                            ))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: screenWidth * 0.482,
                                            child: FractionalTranslation(
                                              translation:
                                                  const Offset(0.025, 0),
                                              child: loadImage(_face),
                                            ))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: screenWidth * 0.482,
                                            child: FractionalTranslation(
                                              translation:
                                                  const Offset(0.025, 0),
                                              child: loadImage(_hair),
                                            ))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: screenWidth * 0.482,
                                            child: FractionalTranslation(
                                              translation:
                                                  const Offset(0.025, 0),
                                              child: loadImage(_clothes),
                                            ))),
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            width: screenWidth * 0.482,
                                            child: FractionalTranslation(
                                              translation:
                                                  const Offset(0.025, 0),
                                              // translation: isears ? const Offset(-0.02, -0.58) : const Offset(-0.02,-0.02),
                                              child: loadImage(_else),
                                            ))),
                                  ],
                                )
                              : Container(),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            SizedBox(
              // height: screenHeight*0.104,
              child: Center(
                child: TextButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all<BorderSide>(
                      const BorderSide(width: 2, color: Colors.black),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xffe87d42)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    print("---");
                    // print(isears);
                    print("---");
                    print(_hairID);
                    print(_faceID);
                    print(_clothesID);

                    _changeItem(apiUrl, _hairID, _faceID, _clothesID, _elseID,
                        _hairPID, _facePID, _clothesPID, _elsePID);
                  },
                  child: const SizedBox(
                    width: 50,
                    height: 22,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '儲存',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 2,
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
            SizedBox(
              height: screenHeight * 0.025,
            ),
            SizedBox(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(categories.length, (index) {
                        return SizedBox(
                          width: screenWidth * 0.18,
                          height: 30,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedCategoryIndex = index;
                                  // print(selectedCategoryIndex);
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  index == selectedCategoryIndex
                                      ? const Color(0xFFC8B495)
                                      : const Color(0xFFAF8233),
                                ),
                                side: MaterialStateProperty.all<BorderSide>(
                                  index == selectedCategoryIndex
                                      ? const BorderSide(
                                          color: Colors.black, width: 1.8)
                                      : const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                categories[index],
                                style: const TextStyle(
                                  // letterSpacing: 1,
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: screenHeight * 0.31,
                child: Container(
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: screenWidth * 0.15),
                        child: SingleChildScrollView(
                          child: CategoryRow(
                            category: categories[selectedCategoryIndex],
                            accessories: getCategoryAccessories(),
                            onAccessorySelected: (selectedAccessory) {
                              // 根据选中的配件信息更新图片
                              setState(() {
                                final String? category =
                                    selectedAccessory['category'];
                                final String? itemId =
                                    selectedAccessory['itemId'];
                                final String? photo =
                                    selectedAccessory['photo'];

                                if (category == '髮型') {
                                  _hair = photo!;
                                  _hairPID = _hairID;
                                  _hairID = itemId!;
                                } else if (category == '五官') {
                                  _face = photo!;
                                  _facePID = _faceID;
                                  _faceID = itemId!;
                                } else if (category == '衣服') {
                                  _clothes = photo!;
                                  _clothesPID = _clothesID;
                                  _clothesID = itemId!;
                                } else if (category == '配件') {
                                  _else = photo!;
                                  _elsePID = _elseID;
                                  _elseID = itemId!;
                                  // isears = itemId == '21' || itemId == '22' || itemId == '23' || itemId == '24' || itemId == '28';
                                }
                              });
                            },
                          ),
                        ),
                      )),
                ))
          ],
        ),
      ])),
    );
  }

  List<Map<String, String>> getCategoryAccessories() {
    List<Map<String, String>> selectedAccessories = [];
    print(selectedCategoryIndex);
    switch (categories[selectedCategoryIndex]) {
      case '五官':
        selectedAccessories = faceAccessories;
        break;
      case '髮型':
        selectedAccessories = hairAccessories;
        break;
      case '衣服':
        selectedAccessories = clothesAccessories;
        break;
      case '配件':
        selectedAccessories = otherAccessories;
        break;
      default:
        // Handle unrecognized category or show empty list
        break;
    }
    return selectedAccessories;
  }
}

class CategoryRow extends StatefulWidget {
  final String category;
  final List<Map<String, String>> accessories;
  final Function(Map<String, String>) onAccessorySelected; // 添加回调函数

  const CategoryRow(
      {super.key,
      required this.category,
      required this.accessories,
      required this.onAccessorySelected});

  @override
  State<CategoryRow> createState() => _CategoryRowState();
}

class _CategoryRowState extends State<CategoryRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: widget.accessories.map((accessory) {
            return GestureDetector(
                onTap: () {
                  final String? itemId = accessory['item_id'];
                  final String? photo = accessory['photo'];

                  // 调用回调函数，传递选中的配件信息
                  widget.onAccessorySelected({
                    'category': widget.category,
                    'itemId': itemId!,
                    'photo': photo!,
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFC8B495),
                        border: Border.all(
                          color: const Color(0xFFC8B495),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(15)),
                    width: 60,
                    height: 60,
                    child: Center(
                      child: Image.network(accessory['photo']!),
                    )));
          }).toList(),
        ),
      ],
    );
  }
}
