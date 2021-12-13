// Flutter 에서는 화면과 페이지를 routes 라고 지칭함
// 안드로이드: activity == route
// iOS: ViewController == route

import 'package:flutter/material.dart';

class NavAndBack extends StatelessWidget {
  const NavAndBack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Nav and Back', home: FirstRoute());
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('First Route')),
        body: Center(
            child: ElevatedButton(
                child: const Text('Open route'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecondRoute()));
                })));
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Second Route')),
        body: Center(
            child: ElevatedButton(
                child: const Text('Open route'),
                onPressed: () {
                  Navigator.pop(context);
                })));
  }
}
