import 'package:app/mail/mail.dart';
import 'package:flutter/material.dart';
import 'package:app/guild.dart';

class ClientWrite extends StatefulWidget {
  const ClientWrite({super.key});

  @override
  _ClientWriteState createState() => _ClientWriteState();
}

class _ClientWriteState extends State<ClientWrite>
    with SingleTickerProviderStateMixin {
  final _focusNode = FocusNode();
  bool isMenuOpen = true;
  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _payController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isStartDate ? startDate ?? DateTime.now() : endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate))
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        // 收起键盘
        FocusScope.of(context).unfocus();
      }
    });
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
      backgroundColor: Colors.brown[50],
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
                image:
                    AssetImage('assets/images/background/img-client-write.png'),
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
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xffcab595),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 2),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            hintText: '標題',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 8),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xffcab595),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          readOnly: true,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 2),
                          onTap: () => _selectDate(context, false),
                          controller: TextEditingController(
                              text: endDate == null
                                  ? ''
                                  : "${endDate!.toLocal()}".split(' ')[0]),
                          decoration: const InputDecoration(
                            hintText: '募集時間',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 8),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xffcab595),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 2),
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '聯絡方式',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 8),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 35,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xffcab595),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 2),
                          controller: _payController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '報酬',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 8),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 15),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: 270,
                        width: 200,
                        decoration: BoxDecoration(
                            color: const Color(0xffcab595),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              letterSpacing: 2),
                          controller: _contentController,
                          maxLines: 10,
                          decoration: const InputDecoration(
                            hintText: '內容',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                letterSpacing: 8),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 11.0, horizontal: 15),
                          ),
                        ),
                      ),
                      TextButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            const BorderSide(width: 2, color: Colors.black),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xffe87d42)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {},
                        child: const SizedBox(
                          width: 60,
                          height: 25,
                          child: Center(
                            child: Text(
                              '登入',
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
