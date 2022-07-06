import 'package:flutter/material.dart';

/*
상태를 바꾸면 해당 상태를 구독중인 자식이 다시 렌더링된다.
(그 자식이 상수형 stateless 위젯이라도 마찬가지 (리액트와 동일))
구 리액트에 있던 did~ 같은 라이프사이클 함수들이 있다.
createState() 를 하면 프레임워크는 상태 트리에 새 상태 객체를 삽입 후 initState()를 호출함
State 의 서브 클래스는 initState 를 재정의할 수 있다.
이는 애니메이션을 구성하거나 특정 기능을 구현하려면 재정의할 수 있다.
상태 객체가 더이상 필요하지 않다면 프레임워크는 dispose()를 호출한다.
위젯 리렌더링(빌드)시 다른 위젯과 일치하는지 여부를 제어하려면 키를 설정해라. (리액트와 동일)
현재 위젯의 runtimeType 과 보이는 순서에 따라 이전 빌드의 위젯을 비교한다. (리액트와 동일)
키는 동일한 타입 위젯의 여러 인스턴스를 빌드하는 위젯에 가장 유용함. (예: 목록, 리액트와 동일)
지역키는 형제간 구분을 위한 키이고, 전역키는 위젯 계층에서 전역적으로 고유해야 한다.
 */

/*
Stateless 위젯은 위젯이 로드될때 딱 한번 그려집니다.
이것은 어떠한 이벤트나 혹은 사용자 액션에 의해서 위젯이 다시 그려지지 않는다는 것을 의미합니다.
Stateful 위젯은 Stateless 위젯과 다르게 수동으로 화면을 리로드할 필요가 없습니다.
Stateful 위젯은 setState 함수가 불리면 자동으로 화면에 다시 그려지기 때문입니다
 */

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({this.count});

  final int? count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      child: const Text('Increment'),
    );
  }
}

class StateExample extends StatelessWidget {
  const StateExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'state example',
      home: _Counter(),
    );
  }
}

class _Counter extends StatefulWidget {
  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      CounterIncrementor(onPressed: _increment),
      CounterDisplay(count: _counter),
    ]);
  }
}
