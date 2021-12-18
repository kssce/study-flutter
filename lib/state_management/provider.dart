/*
state drilling 현상은 RN뿐 아니라 여기에도 존재한다.
상태 전달을 위해 거치는 중간 컴포넌트들도 모두 다시 렌더링이 된다.
그래서 provider 가 필요한 것

Provider 에는 3가지 컨셉이 있다.
1. ChangeNotifier
ChangeNotifier 는 리스너에게 변경 알림을 제공하는 Flutter SDK 에 포함 된
간단한 클래스다. (flutter:foundation 안에 있는 클래스다.)
즉 무언가가 ChangeNotifier 타입이면 우리는 그것의 변화들을 구독할 수 있다.
Observable 같은 것.
Provider 에서는 ChangeNotifier 가 앱 상태를 캡슐화하는 한 방법이라고 함
2. ChangeNotifierProvider
ChangeNotifierProvider 는 자손들에게 ChangeNotifier 인스턴스를
제공해주는 클래스다. 이 클래스는 provider 패키지안에 있다.
사용하고자 하는 위젯 이상 아무곳에 선언하면 되므로 보통 main 에 감싼다.
여러 상태를 사용하려면 MultiProvider 로 먼저 감싼다.
3. Consumer
Consumer 를 통해서 앱상태에 접근해줄 수 있다.
그리고 builder 는 ChangeNotifier 가 변경될때마다 호출되는 함수다.
Consumer 사용시 최대한 위젯 영역을 좁게 잡아야 한다고 권장함
(상태 값을 구독하는 컴포넌트도 StatelessWidget 으로 만들 수 있고
해당 컴포넌트의 사용시에도 컴파일 타임 상수로 취급할 수있으며
상태 변경시 렌더링은 build 가 아닌 build 내부 어딘가에 정의한
Consumer 만 다시 렌더링됨)
context.watch<T>() 사용한 build 함수는 전체가 다시 렌더링됨

Provider 에는 watch, read, select 기능을 제공하고 있습니다.
read: 해당 위젯은 상태값을 읽습니다. 하지만 변경을 감시하지 않습니다.
watch: 해당 위젯이 상태값의 변경을 감시합니다.
select: 해당 위젯은 상태값의 특정 부분만을 감시합니다.
보통 Provider 의 값을 변경하기 위한 함수는 read 를 통해 접근하며,
상태값을 사용할 때에는 watch 를 사용합니다.
변경된 상태값을 표시하기 위해 re-build 가 발생하는데,
이 re-build 는 많은 비용을 사용합니다.
따라서, 다음과 같이 select 를 통해 특정 값의 변경만을 감시하여
re-build 를 최적화 할 수 있습니다.

 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'counter app',
        home: Scaffold(
            appBar: AppBar(title: const Text('Counter app')),
            body: Column(children: [
              Consumer<Counts>(builder: (context, state, child) {
                return Row(
                  children: [
                    TextButton(onPressed: state.remove, child: const Text('-')),
                    Text(state._count.toString()),
                    TextButton(onPressed: state.add, child: const Text('+')),
                  ],
                );
              }),
              const ConsumerWidget(),
              const ContextWidget(),
              const ContextWidgetWithSelect()
            ])));
  }
}

/// provider 를 사용하기 위해서는 ChangeNotifier 를 사용해서
/// 클래스를 생성해야 한다.
class Counts with ChangeNotifier {
  /// 앱 내에서 공유할 상태 변수 정의
  int _count = 0;

  int get count => _count;

  /// 각 액션 정의
  /// 여기서 중요한 점은 변수를 수정하였다면,
  /// notifyListeners()를 실행하여, 데이터가 갱신되었음을 통보합니다.
  /// 마치 Stateful Widget 에서 값이 변경되었음을 알리기 위해
  /// setState 함수를 사용하는 것과 동일한 원리입니다.
  /// notifyListeners 함수를 실행하지 않으면,
  /// 다른 위젯들에서 해당 값이 변경되었는지 인식하지 못합니다.
  /// (옵저버 패턴의 notify)
  void add() {
    _count++;
    notifyListeners();
  }

  void remove() {
    _count--;
    notifyListeners();
  }
}

class ConsumerWidget extends StatelessWidget {
  const ConsumerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SomeWidget');
    return const SomeWidgetsChild();
  }
}

class SomeWidgetsChild extends StatelessWidget {
  const SomeWidgetsChild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('SomeWidgetsChild');
    return Consumer<Counts>(builder: (context, state, child) {
      print('SomeWidgetsChild\'s Consumer');
      return Text(state.count.toString());
    });
  }
}

class ContextWidget extends StatelessWidget {
  const ContextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ContextWidget');
    return Text(context.watch<Counts>().count.toString());
  }
}

class ContextWidgetWithSelect extends StatelessWidget {
  const ContextWidgetWithSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ContextWidgetWithSelect');
    return Text(context.select((Counts c) => c.count.toString()));
  }
}
