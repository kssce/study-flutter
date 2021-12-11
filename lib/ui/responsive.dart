import 'package:flutter/material.dart';

// 반응형 디자인으로 Flutter 앱을 만드는 방법은 두 가지가 있다.
// 1. LayoutBuilder 클래스 사용 (이건 부모 위젯에 대한 정보(제약조건) 제공)
//   MediaQuery 를 써서 하나씩 얻을 수 있지만, 모든 것을 한 번에 쉽게 해결하는 것이 LayoutBuilder
//   위젯의 크기에 따라 build.
//   LayoutBuilder 의 builder function 은 layout 타임에 불리게 되고 constraints 를 제공
//   정확히는
//     1. 처음으로 widget 이 layout 될 대
//     2. 부모 widget 의 constraints 가 바뀔 때
//     3. 부모 widget 이 해당 widget 을 업데이트 할 때
//   불리게 됨
//   부모 widget 이 같은 값의 constraint 를 계속 넘겨주게 되는 상황에서는
//   builder function 이 불리지 않음
// 2. 빌드 함수에서 MediaQuery.of() 메서드 사용 (이건 화면 자체에 대한 정보)
//   기기 화면 관련 정보를 구할 수 있다.
//   MediaQuery.of()를 사용하면 media query 가 변할때마다 widget 이 rebuild 됨
//   보통 기기가 회전할때 변함(창 조절이나)
//   padding: System UI 로 인해 완전히 가려진 부분 (일반적으로 노치나 status bar)
//   viewInsets: System UI 로 인해 완전히 가려진 부분 (일반적으로 키보드)
// Orientation 만 받아오는 OrientationBuilder 도 있음
// Flexible 위젯은 flex 숫자를 지정하고, fit 을 지정해서 남은 공간을 어떻게 채울 것인지
// 정의 가능하다. RN 이나 웹처럼 flex 관련 속성을 쓰려면 모든 자식에 Flexible 을 감쌀 필요가 없고
// 부모도 플렉스 관련 속성일 필요가 없다.

// FittedBox: 특정 위젯의 남는 부분에 대해서 어떻게 처리할지 정하는 위젯
// 예를 들면 이미지가 가로세로 비율에 따라 남거나 넘치는 경우 어떻게 처리할지
// FractionallySizedBox: 부모 사이즈 기준으로 비율로 너비 높이 지정 가능

class Responsive extends StatelessWidget {
  const Responsive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'responsive',
        home: Scaffold(
            appBar: AppBar(title: const Text('Responsive app study')),
            body: ListView(children: [
              const MyMediaQuery(),
              const SizedBox(height: 500, child: MyLayoutBuilder()),
              _aspectRatio()
            ])));
  }
}

class MyMediaQuery extends StatelessWidget {
  const MyMediaQuery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 미디어 쿼리(화면 관련 정보)가 변할때마다 build 함수가 재실행됨(리렌더링)
    final data = MediaQuery.of(context);
    final screenSize = data.size;
    final orientation = data.orientation;
    final padding = data.padding;
    final insets = data.viewInsets;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            "width: ${screenSize.width}\nheight: ${screenSize.height}\nratio: ${screenSize.aspectRatio}"),
        Text("orientation: ${orientation.toString()}"),
        Text("top padding: ${padding.top}\nbottom padding: ${padding.bottom}"),
        Text("top insets: ${insets.top}\nbottom insets: ${insets.bottom}")
      ],
    );
  }
}

class MyLayoutBuilder extends StatelessWidget {
  const MyLayoutBuilder({Key? key}) : super(key: key);

  Widget oneBoxedContainer() {
    return Container(
      color: Colors.red,
      width: 100,
      height: 100,
    );
  }

  Widget twoBoxedContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.red,
          width: 100,
          height: 100,
        ),
        Container(color: Colors.blue, width: 100, height: 100),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight;
      final ratio = width / height;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("width: $width\nheight: $height\nratio: $ratio"),
          const SizedBox(height: 20),
          Container(
              height: 300, width: 300 * ratio, color: Colors.blueGrey[100]),
          const SizedBox(height: 20),
          ratio >= 1 ? twoBoxedContainer() : oneBoxedContainer()
        ],
      );
    });
  }
}

Widget _aspectRatio() {
  // ListView 는 교차축 옵션이 기본 값이면 stretch 하기 때문에 제대로 나오게 해야
  // AspectRatio 동작함
  return Center(
      child: Container(
          decoration: BoxDecoration(color: Colors.blue[500]),
          height: 100.0,
          child: AspectRatio(
              aspectRatio: 20/9, child: Container(color: Colors.yellow))));
}
