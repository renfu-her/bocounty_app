import 'dart:convert';
import 'package:app/user/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/main.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  BoxDecoration? backgroundImage; // 用于存储背景图片装饰

  @override
  void initState() {
    super.initState();

    ImageProvider imageProvider = AssetImage('assets/images/item/edit.png');
    ImageStream stream = imageProvider.resolve(const ImageConfiguration());

    stream.addListener(ImageStreamListener((info, synchronousCall) {
      double imageWidth = info.image.width.toDouble();
      double imageHeight = info.image.height.toDouble();

      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      double widthRatio = screenWidth / imageWidth;
      double heightRatio = screenHeight / imageHeight;

      BoxFit fit;
      if (widthRatio > heightRatio) {
        fit = BoxFit.fitHeight;
      } else {
        fit = BoxFit.fitWidth;
      }

      // 更新背景图片的装饰
      setState(() {
        backgroundImage = BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: fit,
          ),
        );
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: backgroundImage, // 應用背景圖片的裝飾
        // 其他内容...
      ),
    );
  }
}
