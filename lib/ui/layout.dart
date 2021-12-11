// Flutter 레이아웃 메커니즘의 핵심은 위젯입니다. Flutter 에서는 거의 모든 것이 위젯이고
// 심지어 레이아웃 모델도 위젯이죠. Flutter 앱 내에서 볼 수 있는 이미지, 아이콘, 글자
// 모두 위젯입니다.
// 하지만 row, column, grid 같이 볼 수 없는 위젯들도 있는데요.
// 이들은 보이는 위젯들을 제어하고, 제한하며, 정렬시켜줍니다.

// Container 는 자식 위젯들을 커스터마이징할 수 있는 위젯 클래스인데요. 여백, 간격,
// 테두리 또는 배경색을 추가하고 싶을 때 Container 를 사용할 수 있습니다.
// 예를 들면 텍스트나 Row 에 간격을 추가하고 싶으면 Container 안에 배치 해야 함
// 이런 레이아웃이 아닌 스타일은 직접 지정하면 된다.

// 레이아웃 위젯: 보이는 위젯에 대해 정렬, 제한하는 다양한 방법을 지닌 위젯
// Material UI 디자인을 적용하려면 Material 로 감싸야 한다.
// 감싸지 않으면 제목, 앱바, 배경색 등이 포함되지 않는다.
// MaterialApp 은 Material UI 를 사용할 수 있게 해주는 클래스
// 타이틀 지정(안드로이드에서만 유효한 속성으로, 최근 사용한 앱 목록에 보여지는 text), 테마 지정 가능
// 네비게이션도 지정할 수 있다.
// Scaffold 와 Material 의 차이점은, 전자는 appBar, body 를 제공하며, 후자는 그냥
// Material UI를 제공하는 빈 종이 같은 개념이다.

// 레이아웃이 너무 커서 장치에 맞지 않으면 영향을 받는 가장자리를 따라 노란색 및 검은색 줄무늬 패턴이 나타남

import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'layout',
        home: Scaffold(
            appBar: AppBar(title: const Text('Layout Example')),
            body: Column(children: [
              Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.green[100]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // mainAxisSize: MainAxisSize.min, // 여분 공간 압축시켜서 최소 사이즈로 만듦
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/cat2.png'),
                        Expanded(child: Box(Colors.red[100]), flex: 2),
                        // flexbox 의 flex-grow 와 동일
                        // Box(),
                        Box(),
                      ])),
              // 남은 공간에 맞게 가로 세로 비율 유지해서 들어감
              Expanded(child: Image.asset('assets/images/cat1.png')),
              leftColumn
            ])));
  }
}

// 너무 중첩된 경우 변수로 분리해서 사용할 수 있음
final leftColumn = Container(
    height: 100,
    decoration: BoxDecoration(color: Colors.green[100]),
    padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Box(),
      Box(),
      Box(),
    ]));

class Box extends StatelessWidget {
  Box([Color? color]) {
    this.color = color ?? Colors.blue[500];
  }

  Color? color;

  @override
  Widget build(BuildContext context) => genBox(color);
}

// 굳이 반드시 Widget 으로 감싸지 않아도 됨.
// 프레임워크 특성상 중첩이 굉장히 잘 발생하기 때문에
// 공식 문서에서도 너무 중첩된 경우 함수나 위젯으로 분리하라고 자주 언급함
// 스타일 역시 마찬가지로 분리할 수 있으면 분리해서 정의.
Widget genBox(Color? color) => Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: color),
    );
