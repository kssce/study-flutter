// 1. 경로에 전달해야 하는 인수 클래스로 정의
// 2.a 일반적인 routes 에 정의해서 내부에서
//   ModalRoute.of(context)!.settings.arguments as T 로 arguments 사용
// 2.b 메인 화면 build 에서 onGenerateRoute 콜백에 settings 를 받아서
//   내부에서 MaterialPageRoute 로 직접 라우팅 해줄 수 있다.
// 둘 중 편한 방법으로 사용하면 됨

import 'package:flutter/material.dart';

class PassArgToNamedRoute extends StatelessWidget {
  const PassArgToNamedRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass arg to named route',
      routes: {
        _ExtractArgumentsScreen.routeName: (context) =>
            const _ExtractArgumentsScreen()
      },
      // 명명된 route 를 처리하는 함수 제공
      onGenerateRoute: (settings) {
        if (settings.name == _PassArgumentsScreen.routeName) {
          print("routing > ${settings.name}");
          final args = settings.arguments as _ScreenArguments;
          return MaterialPageRoute(builder: (context) {
            return _PassArgumentsScreen(
                title: args.title, message: args.message);
          });
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home Screen'),
        ),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, _ExtractArgumentsScreen.routeName,
                    arguments: _ScreenArguments('Extract Arguments Screen',
                        'This message is extracted in the build method.'));
              },
              child: const Text('Navigate to screen that extracts arguments')),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, _PassArgumentsScreen.routeName,
                    arguments: _ScreenArguments(
                        'Accept Arguments Screen',
                        'This message is extracted in the onGenerateRoute'
                            ' method.'));
              },
              child: const Text('Navigate to screen that extracts arguments')),
        ])));
  }
}

class _ExtractArgumentsScreen extends StatelessWidget {
  const _ExtractArgumentsScreen({Key? key}) : super(key: key);

  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as _ScreenArguments;

    return Scaffold(
        appBar: AppBar(
          title: Text(args.title),
        ),
        body: Center(child: Text(args.message)));
  }
}

class _PassArgumentsScreen extends StatelessWidget {
  const _PassArgumentsScreen(
      {Key? key, required this.title, required this.message})
      : super(key: key);

  static const routeName = '/passArguments';

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(child: Text(message)));
  }
}

class _ScreenArguments {
  final String title;
  final String message;

  _ScreenArguments(this.title, this.message);
}
