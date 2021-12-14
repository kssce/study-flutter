import 'package:flutter/material.dart';

// Controller: 시작 방향, 등 애니메이션 자체를 컨트롤
// Animation: 어떻게 값을 animate 할 지 미리 정해진 것으로,
//  두 개의 값(혹은 타입) 사이의 보간된 숫자를 생성한다.
// CurvedAnimation: 애니메이션 진행 상황을 비선형 곡선으로 정의
// vsync: 오프스크린 애니메이션이 불필요한 리소스를 소비하는 것을 방지

class BasicAnim extends StatelessWidget {
  const BasicAnim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Implicit 1'),
        ),
        body: const _Logo());
  }
}

class _Logo extends StatefulWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  _LogoState createState() => _LogoState();
}

// vsync 를 사용하기 위해 SingleTickerProviderStateMixin 사용
class _LogoState extends State<_Logo> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {
          // ...
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: const FlutterLogo(),
      ),
    );
  }
}
