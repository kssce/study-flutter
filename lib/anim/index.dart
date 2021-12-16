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
import 'package:intro_flutter/anim/staggered1.dart';
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
      '/hero/radial': (context) => const RadialExpansionDemo(),
      '/staggered/1': (context) => const BasicStaggeredDemo()
    });
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeBtn = buildRouteBtnWith(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Animation Home'),
        ),
        body: Center(
            child: Column(children: [
          routeBtn(path: '/implicit/1', title: 'implicit 1'),
          routeBtn(path: '/tween/1', title: 'tween 1'),
          routeBtn(path: '/tween/2', title: 'tween 2'),
          routeBtn(path: '/hero', title: 'hero'),
          routeBtn(path: '/hero/radial', title: 'radial hero'),
          routeBtn(path: '/staggered/1', title: 'staggered 1'),
        ])));
  }
}

Widget Function({required String path, required String title}) buildRouteBtnWith(BuildContext context) =>
    ({required String path, required String title}) => ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, path);
        },
        child: Text(title));
