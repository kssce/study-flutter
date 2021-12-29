/*
Flutter 위젯은 React 컴포넌트에서 영감을 얻었다.
위젯의 상태가 변경되면 위젯은 기술된 내용을 다시 작성하고
렌더 트리에서 다음 상태로 전환하는 데 필요한 최소한의 변경 사항을 결정하기 위해
이전 설명과 비교한다.

Row, Column 은 flexbox 의 direction 옵션 적용한 것과 동일하다
Stack 은 position: absolute 와 동일
Container 는 div, View 와 동일
BoxDecoration 는 배경
 */

import 'package:flutter/material.dart';

class _BasicAppBar extends StatelessWidget {
  _BasicAppBar({ this.title });

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 56.0, // in logical pixels
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // 좌우 8픽셀
        decoration: BoxDecoration(color: Colors.blue[500]),
        child: Row(
          // <Widget> is the type of items in the list.
            children: <Widget>[
              const IconButton(
                icon: Icon(Icons.menu),
                tooltip: 'Navigation menu',
                onPressed: null, // null disables the button
              ),
              // 다른 자식이 사용하지 않는 공간을 채우는 UI 위젯 (like flex)
              Expanded(
                child: title ?? const Text('I\'m fallback'),
              ),
              const IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search',
                onPressed: null,
              )
            ]
        )
    );
  }
}

class _BasicScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Materials is a conceptual piece of paper on which the UI appears.
    return Material( // material UI 효과용 래핑 위젯
      // Column is a vertical, linear layout.
      child: Column(
        children: <Widget>[
          _BasicAppBar(
            title: Text(
              'Happy Hacking',
              style: Theme
                  .of(context)
                  .primaryTextTheme
                  .headline6,
            ),
          ),
          const Expanded(
            child: Center(
                child: Text('Hello, Developer!')
            ),
          ),
        ],
      ),
    );
  }
}

class Introduction extends StatelessWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 진입 화면에는 MaterialApp 사용 (네비게이션을 구성함)
      title: 'introduction',
      home: _BasicScaffold(),
    );
  }
}
