import 'package:flutter/material.dart';

/*
Hero 위젯은 `두 화면`을 애니메이션으로 연결
tag 는 Hero 를 식별하는 객체로 반드시 동일해야 함
멀티미디어 같은거 확대 보기할때 간편하게 사용할 수 있을 것 같다.
 */
class Basic extends StatelessWidget {
  const Basic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Nav Basic',
      home: MainScreen(),
    );
  }
}


class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Nav Basic')),
        body: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DetailScreen();
              }));
            },
            child: Hero(
                tag: 'imageHero',
                child: Image.asset('assets/images/cat1.png'))));
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
                child: Hero(
                    tag: 'imageHero',
                    child: Image.asset('assets/images/cat2.png')))));
  }
}
