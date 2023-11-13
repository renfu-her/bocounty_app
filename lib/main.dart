import 'package:flutter/material.dart';
import 'package:app/login.dart';

String apiUrl = "http://192.168.0.195";
String User_Token = "";

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        dialogTheme: DialogTheme(
          backgroundColor: const Color(0xffF0E7D3), // 背景颜色
          contentTextStyle: const TextStyle(
            fontSize: 15,
            color: Color(0x8B211F15), // 内容文本颜色
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black, // 按钮文本颜色
          ),
        ),
      ),
      home: const LoginPage(), // 将LoginPage添加到应用程序中
      // home.dart: const SignInPage(),
    );
  }
}
