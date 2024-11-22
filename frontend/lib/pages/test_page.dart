import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:okay_life_app/api/api_client.dart';
import 'package:okay_life_app/pages/start_page.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final TextEditingController _testController = TextEditingController();
  bool isFilled = false;
  final List<String> hintTexts = [
    "전 세계 30개국 여행하기",
    "1년 안에 1000만원 모으기",
    "유튜브 채널 30만 구독자 모으기",
    "유명 이모티콘 작가 되기",
    "6개월 내 체지방률 20% 이하 만들기",
    "부지런한 생활 습관 만들기"
  ];
  int _currentHintIndex = 0;
  Timer? _hintTimer;

  @override
  void initState() {
    super.initState();

    // 텍스트 필드 변경 상태 감지
    _testController.addListener(() {
      setState(() {
        isFilled = _testController.text.isNotEmpty;
      });
    });

    // 힌트 텍스트 순환 타이머
    _hintTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _currentHintIndex = (_currentHintIndex + 1) % hintTexts.length;
      });
    });
  }

  @override
  void dispose() {
    _hintTimer?.cancel(); // 타이머 정리
    _testController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (!isFilled) return;

    final inputText = _testController.text;

    try {
      final response = await ApiClient.post(
        '/users',
        data: {'value': inputText},
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Data sent successfully: ${response['message']}")),
      );

      setState(() {
        _testController.clear();
        isFilled = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send data: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "당신의 우주를\n알려주세요",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "5년 안에 달성하고 싶은 구체적인 목표를\n작성하는 것이 좋습니다 :)",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 250,
                    height: 250,
                    child: Lottie.asset("assets/test_planet.json"),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: TextField(
                      controller: _testController,
                      maxLength: 20,
                      decoration: InputDecoration(
                        hintText: hintTexts[_currentHintIndex], // 힌트 텍스트
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 17,
                        ),
                        filled: true,
                        fillColor: const Color(0xff6976b6).withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        counterText: '',
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: isFilled
                        ? () {
                            _submitData();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StartPage()));
                          }
                        : null,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: isFilled ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 1.0)),
                      child: Text(
                        "시작",
                        style: TextStyle(
                            color: isFilled
                                ? Color(0xff0a1c4c)
                                : Colors.white.withOpacity(0.5),
                            fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
