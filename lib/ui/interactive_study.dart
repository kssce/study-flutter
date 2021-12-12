// State 클래스가 자식 위젯(Stateless, Statefull)을 가질 수 있고,
// State 클래스 내에 정의된 상태나 메소드를 자식에게 주면 자식은 자신의 상태 없이
// 부모의 상태를 구독하면서 조작할 수 있다. (일반적인 RN 패턴)
import 'package:flutter/material.dart';

class InteractiveExample extends StatelessWidget {
  const InteractiveExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interactive example',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Interactive example'),
        ),
        body: const Center(
          child: TapboxA(),
        ),
      ),
    );
  }
}

class TapboxA extends StatefulWidget {
  const TapboxA({Key? key}) : super(key: key);

  @override
  _TapboxAState createState() => _TapboxAState();
}

class _TapboxAState extends State<TapboxA> {
  bool _active = false;

  void _handleTap() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      // 여러 제스처 가능
      child: Container(
        child: Center(
          child: Text(
            _active ? 'Active' : 'Inactive',
            style: const TextStyle(fontSize: 32.0, color: Colors.white),
          ),
        ),
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          color: _active ? Colors.lightGreen[700] : Colors.grey[600],
        ),
      ),
    );
  }
}
