import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JankenPage(),
    );
  }
}

class JankenPage extends StatefulWidget {
  const JankenPage({Key? key}) : super(key: key);

  @override
  State<JankenPage> createState() => _JankenPageState();
}

class _JankenPageState extends State<JankenPage> {
  String myHand = '✊';
  String computerHand = '✊';
  String result = '引き分け';

  // プレイヤーが選んだ手をstateに反映
  void selectHand(String selectedHand) {
    myHand = selectedHand;
    print(selectedHand);
    generateComputerHand();
    judge();
    setState(() {});
  }

  // コンピュータの手をランダムに決定
  void generateComputerHand() {
    // nextInt() の括弧の中に与えた数字より1小さい値を最高値としたランダムな数を生成する。
    // 3 であれば 0, 1, 2 がランダムで生成される。
    final randomNumber = Random().nextInt(3);
    computerHand = randomNumberToHand(randomNumber);
  }

  // ランダムな数字を✊, ✌️, 🖐に変換
  String randomNumberToHand(int randomNumber) {
    switch (randomNumber) {
      case 0:
        return '✊';
      case 1:
        return '✌️';
      case 2:
        return '🖐';
      default:
        return '✊';
    }
  }

  // 勝敗を判定
  void judge() {
    if (myHand == computerHand) {
      result = '引き分け';
    } else if (myHand == '✊' && computerHand == '✌️' ||
        myHand == '✌️' && computerHand == '🖐' ||
        myHand == '🖐' && computerHand == '✊') {
      result = '勝ち';
      // 負けの場合
    } else {
      result = '負け';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('じゃんけん'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 勝敗結果を表示
            Text(
              result,
              style: TextStyle(
                  fontSize: 32
              ),
            ),
            SizedBox(height: 16),
            // コンピュータの手
            Text(
              computerHand,
              style: TextStyle(
                  fontSize: 32
              ),
            ),
            SizedBox(height: 16),
            // プレイヤーの手
            Text(
              myHand,
              style: TextStyle(
                fontSize: 32
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    selectHand('✊');
                  },
                  child: Text('✊'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('✌️');
                  },
                  child: Text('✌️'),
                ),
                ElevatedButton(
                  onPressed: () {
                    selectHand('🖐');
                  },
                  child: Text('🖐'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


