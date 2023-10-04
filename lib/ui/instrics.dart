import 'package:flutter/material.dart';

/// 매우 중요한 예제
/// 하위 위젯의 본질적인 크기를 측정해야 하기 때문에
/// IntrinsicHeight을 사용하면 때로는 성능 문제가
/// 발생할 수 있다는 점은 주목할 가치가 있습니다.
class Instrics extends StatelessWidget {

  const Instrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('IntrinsicWidth and IntrinsicHeight Example')),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 가장 큰 자식 높이에 맞춤
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    color: Colors.blue,
                    width: 100,
                    child: const Text('Box 1'),
                  ),
                  Container(
                    color: Colors.green,
                    width: 150,
                    child: const Text('Box 2\nwith\nmultiple\nlines'),
                  ),
                  Container(
                    color: Colors.orange,
                    width: 75,
                    child: const Text('Box 3'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            /// 가장 큰 자식 너비에 맞춤
            IntrinsicWidth(
              child: Column(
                children: [
                  Container(
                    color: Colors.purple,
                    child: const Text('This is a really long text that should wrap to multiple lines'),
                  ),
                  Container(
                    color: Colors.red,
                    child: const Text('Short text'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
