// AnimationController: 하드웨어가 새 프레임을 준비할 때마다 새 값을 생성하는 특수 객체

// 무상태 애니메이션은 AnimatedWidget
// 복잡한 애니메이션은 AnimatedBuilder 위젯으로 구현

// AnimationContainer: 암시적 애니메이션 위젯으로, 간편하게 사용 가능하며
// 자동으로 보간한다.
// todo SingleTickerProviderStateMixin
// todo vsync
// todo AnimationController
// todo Animation
import 'package:flutter/material.dart';
import 'package:intro_flutter/anim/radial_hero.dart';
import 'package:intro_flutter/anim/tween.dart';

import 'hero.dart';
import 'implicit.dart';
import 'tween2.dart';

class AnimBasic extends StatelessWidget {
  const AnimBasic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Animation Tutorial', initialRoute: '/', routes: {
      '/': (context) => const _HomeScreen(),
      '/implicit/1': (context) => const ImplicitContainer(),
      '/tween/1': (context) => const TweenContainer(),
      '/tween/2': (context) => const Tween2(),
      '/hero': (context) => const HeroAnimation(),
      '/hero/radial': (context) => const RadialExpansionDemo()
    });
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Animation Home'),
        ),
        body: Center(
            child: Column(children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/implicit/1');
              },
              child: const Text('implicit 1')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tween/1');
              },
              child: const Text('tween 1')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tween/2');
              },
              child: const Text('tween 2')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hero');
              },
              child: const Text('hero')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hero/radial');
              },
              child: const Text('radial hero'))
        ])));
  }
}
