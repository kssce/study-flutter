import 'package:flutter/material.dart';

class ReturnDataFromScreen extends StatelessWidget {
  const ReturnDataFromScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Return data from screen',
      home: _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Returning Data Example'),
        ),
        body: const Center(
          child: _SelectionButton(),
        ));
  }
}

class _SelectionButton extends StatelessWidget {
  const _SelectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _navigateAndDisplaySelection(context);
        },
        child: const Text('Pick an option, any option!'));
  }

  // SelectionScreen 을 시작하고 Navigator.pop 의 결과를 기다리는 메소드
  void _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push 는 선택 화면에서
    // Navigator.pop 을 호출한 후 완료되는 Future 를 반환합니다
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectionScreen()),
    );

    // 선택 화면이 결과를 반환한 후 이전 스낵바를 모두 숨기고 새 결과를 표시합니다.
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('${result ?? 'nothing...'}')));
  }
}

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, 'Yep!');
                  },
                  child: const Text('Yep!')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'Nope.');
                },
                child: const Text('Nope.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
