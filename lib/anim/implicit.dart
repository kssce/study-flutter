// 암시적 애니메이션 위젯들은 자동으로 변경사항을 애니메이션 합니다.
// 애니메이션을 사용하면 대상 값을 설정하여 위젯 속성에 애니메이션을 적용할 수 있습니다.
// 대상 값이 변경될 때마다 위젯은 이전 값에서 새 값으로 특성에 애니메이션을 적용합니다.
// 컨트롤러 등으로 애니메이션 효과를 관리하지 않습니다.
// (암시적 애니메이션은 자동으로 변경 사항을 애니메이션 함)
// 값을 통한 애니메이션으로
// old value 와 new value 의 사이를 보간(Interpolation)합니다
// 암시적 애니메이션 위젯은 이 보간을 처리합니다.
// (특정 키(시점)을 지정하고 그 사이를 보간하는 방식)

// AnimatedDefaultTextStyle: Text 관련 스타일이 바뀔 때마다 자동적으로 애니메이션
// AnimatedOpacity: 지정된 opacity 가 변경될 때마다 지정된 duration 동안 child 의 opacity 를 자동으로 애니메이션
// AnimatedPadding: 패딩이 변경되면  자동으로 애니메이션
// AnimatedPhysicalModel: borderRadius 와 elevation 이 변경될 때마다 자동으로 애니메이션
// AnimatedPositioned: Stack 위젯에서 자식의 위치를 제어하며
//   지정된 위치가 변경될 때마다 지정된 기간 동안 자식의 위치를 자동으로 애니메이션
// AnimatedTheme: 지정된 Theme 이 변경될 때마다 지정된 Duration 동안 색상 등을 자동으로 전환하는 Theme 애니메이션
// AnimatedSize: 주어진 자녀의 크기가 변할 때마다 주어진 기간 동안 자동으로 크기를 전환하는 애니메이션 위젯
// AnimatedCrossFade: 두 자식 사이에서만 페이드 되지만 크기를 보강하며 뒤집습니다.
// AnimatedSwitcher: 새 위젯과, AnimatedSwitcher 에서 자식으로 설정 한 위젯 간에 크로스 페이드를 수행하는 위젯

// transitionBuilder :

import 'package:flutter/material.dart';

class ImplicitContainer extends StatefulWidget {
  const ImplicitContainer({Key? key}) : super(key: key);

  @override
  _AnimatedContainerState createState() => _AnimatedContainerState();
}

// AnimatedContainer 는 CSS 트랜지션과 매우 유사
class _AnimatedContainerState extends State<ImplicitContainer> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Implicit Screen'),
        ),
        body: GestureDetector(
            onTap: () {
              setState(() {
                _selected = !_selected;
              });
            },
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(children: [
                  dynamicBox(_selected),
                  transparentBox(_selected),
                  physicalBox(_selected),
                  themeBox(_selected),
                  crossFade(_selected),
                  _AnimatedSwitcherScreen(),
                  // positionedBox(_selected)
                ]))));
  }
}

Widget dynamicBox(bool selected) {
  return AnimatedContainer(
    width: selected ? 300.0 : 100.0,
    height: selected ? 100.0 : 300.0,
    alignment: selected ? Alignment.center : AlignmentDirectional.topCenter,
    duration: const Duration(milliseconds: 500),
    decoration: BoxDecoration(
      border: selected
          ? Border.all(color: Colors.black, width: 3)
          : Border.all(color: Colors.red, width: 3),
      gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: selected
            ? [Colors.lightGreen, Colors.redAccent]
            : [Colors.orange, Colors.deepOrangeAccent],
        stops: const [0.0, 1.0],
      ),
      color: selected ? Colors.red : Colors.blue,
    ),
    curve: Curves.fastOutSlowIn,
    child: const FlutterLogo(size: 75),
  );
}

Widget transparentBox(bool selected) {
  return AnimatedOpacity(
      opacity: selected ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 500),
      child: const FlutterLogo(size: 60));
}

Widget physicalBox(bool selected) {
  return AnimatedPhysicalModel(
      child: Container(
          height: 120,
          width: 120,
          color: Colors.blue[50],
          child: const FlutterLogo(size: 60)),
      shape: BoxShape.rectangle,
      elevation: selected ? 0 : 10.0,
      color: Colors.white,
      shadowColor: Colors.black,
      duration: const Duration(milliseconds: 500));
}

Widget positionedBox(bool selected) {
  return AnimatedPositioned(
      curve: Curves.fastOutSlowIn,
      left: selected ? 10 : 100,
      top: selected ? 70 : 100,
      right: selected ? 10 : 100,
      bottom: selected ? 70 : 100,
      child: Container(color: Colors.blue),
      duration: const Duration(milliseconds: 500));
}

Widget themeBox(bool selected) {
  return AnimatedTheme(
      child: const Center(
          child: Card(
              child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'theme',
                    style: TextStyle(fontSize: 24),
                  )))),
      duration: const Duration(milliseconds: 500),
      data: selected ? ThemeData.light() : ThemeData.dark());
}

Widget crossFade(bool selected) {
  return AnimatedCrossFade(
      firstChild:
          const FlutterLogo(style: FlutterLogoStyle.horizontal, size: 100.0),
      secondChild:
          const FlutterLogo(style: FlutterLogoStyle.stacked, size: 100.0),
      crossFadeState:
          selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 500));
}



class _AnimatedSwitcherScreen extends StatefulWidget {
  @override
  _AnimatedPositionedDirectionalScreenState createState() =>
      _AnimatedPositionedDirectionalScreenState();
}

class _AnimatedPositionedDirectionalScreenState
    extends State<_AnimatedSwitcherScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            // Animation: 어떻게 값을 animate 할 지 정해져있는 객체
            transitionBuilder: (Widget child, Animation<double> animation) {
              // return ScaleTransition(child: child, scale: animation);
              return FadeTransition(opacity: animation, child: child);
            },
            child: Text(
              '$_count',
              // 각 위젯이 다른 key 를 가져야 애니메이션ㅇ ㅣ일어남
              key: ValueKey<int>(_count),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30.0),
            child: TextButton(
              child: const Text('Increment'),
              onPressed: () {
                setState(() {
                  _count += 1;
                });
              },
            ),
          ),
        ],
      );
  }
}
