import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BasicStateMng extends StatefulWidget {
  const BasicStateMng({Key? key}) : super(key: key);

  @override
  _BasicStateMngState createState() => _BasicStateMngState();
}

class _BasicStateMngState extends State<BasicStateMng> {
  final title = 'state mng basic';
  String name = '왈도';

  void setName(String name) {
    setState(() {
      this.name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: title,
        home: Profile(title: title, name: name, setName: setName));
  }
}

class Profile extends StatelessWidget {
  const Profile(
      {Key? key,
      required this.title,
      required this.name,
      required Function this.setName})
      : super(key: key);

  final String title;
  final String name;
  final Function setName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Column(
          children: [
            const ConstSTLWithoutProp(),
            ConstSTLWithProp(name: name),
            STLWithoutProp(),
            Name(name: name, setter: setName),
            const Spacer(),
            NameWithoutState(name: name, setter: setName),
          ],
        ));
  }
}

/// 무상태 클래스는 리렌더링시 상태를 유지하지 않음
class Name extends StatefulWidget {
  const Name({Key? key, required this.name, required this.setter}) : super(key: key);

  final String name;
  final Function setter;

  @override
  _NameState createState() => _NameState();
}

class _NameState extends State<Name> {
  String _inputText = '';
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(widget.name),
      TextField(
          controller: _controller,
          onChanged: (text) {
            setState(() {
              _inputText = text;
            });
          }),
      TextButton(
          onPressed: () {
            // widget.setter(_inputText);
            widget.setter(_controller.text);
          },
          child: const Text('입력'))
    ]);
  }
}

/// 값 구독이 없는 const 생성자 무상태 위젯은 렌더링 다시 하지 않음
class ConstSTLWithoutProp extends StatelessWidget {
  const ConstSTLWithoutProp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('ConstSTLWidget');
    return const Text('Something...');
  }
}

/// 값 구독이 있는 const 생성자 무상태 위젯은 매 프레임마다 렌더링 함
/// 값을 구독하면 외부에서 const 로 선언할 수 없기 때문
class ConstSTLWithProp extends StatelessWidget {
  const ConstSTLWithProp({Key? key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    print('STLWidget');
    return Text(name);
  }
}

/// 값 구독이 없는 무상태 위젯은 매 프레임마다 렌더링 함
/// 선언부에서 const 로 지정하지 않으면 매 프레임마다 렌더링
/// const 는 컴파일 타임 상수기 때문에 리터럴과 같이 취급한다.
/// 따라서 대부분의 경우 컴파일 상수 상태없는 위젯을 만드는 것이 좋음
class STLWithoutProp extends StatelessWidget {
  STLWithoutProp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('STLWithoutProp');
    return const Text('STLWithoutProp');
  }
}




/// 매 프레임에 새로 그림
class NameWithoutState extends StatelessWidget {
  NameWithoutState({Key? key, required this.name, required this.setter}) : super(key: key) {
    print('NameWithoutState');
  }

  final String name;
  final Function setter;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(name),
      TextField(controller: _controller),
      TextButton(onPressed: () {
        setter(_controller.text);
      }, child: const Text('입력'))
    ]);
  }
}
