// constraints 는 최소 너비, 최대 너비, 높이로 구성되며, 크기는 특정 너비와 높이로 구성됨
// 가능한 최대 크기로 하고 싶은 경우. 예를 들어, Center 및 ListView에서 사용하는 박스들이 있습니다.
// 자식 요소들과 같은 크기로 만들려는 경우. 예를 들어, Transform 및 Opacity에서 사용하는 박스들이 있습니다.
// 개별적인 크기를 갖게 하려는 경우. 예를 들어, Image 및 Text에서 사용하는 박스들이 있습니다.

// Unbounded constraints 는 최대 너비나 최대 높이가 double.INFINITY 인 것으로,
// ListView 및 다른 ScrollView 의 하위 클래스 내부에 적용된다.
// 또한 플렉스 박스(Row, Column)의 내부도 마찬가지.
import 'package:flutter/material.dart';

class MyBoxConstraints extends StatelessWidget {
  const MyBoxConstraints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "box constraints",
      home: Scaffold(
        appBar: AppBar(title: const Text("Box Constraints")),
        body: const Text("hi")
      )
    );
  }
}
