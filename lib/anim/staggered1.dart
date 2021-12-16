import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/scheduler.dart' show timeDilation;

/*
Staggered 애니메이션은 순차 또는 겹치는 애니메이션으로 구성됨
따라서 여러 Animation 객체를 사용한
하나의 AnimationController 는 모든 Animation 을 제어
각 Animation 객체는 Interval 동안 애니메이션을 지정
애니메이션되는 각 속성에 대해 트윈을 생성함

이 애니메이션은 한번에 모두가 아니라 일련의 작업으로 발생한다.
순차적이거나 부분적으로 혹은 완전히 겹칠 수 있으며, 변경 사항이
발생하지 않는 간격이 있을 수 있다.

모든 애니메이션은 동일한 AnimationController 에 의해 구동됨
애니메이션이 실시간으로 지속되는 시간에 관계없이
컨트롤러의 값은 0.0에서 1.0 사이여야 함
각 애니메이션에는 0.0에서 1.0 사이의 간격이 있음
간격으로 애니메이션되는 각 속성은 트윈을 만듦
Tween 은 해당 속성의 시작 및 끝 값을 지정
Tween 은 컨트롤러에서 관리하는 Animation 객체를 생성

모든 대화형 위젯과 마찬가지로
전체 애니메이션은 상태 비저장 위젯과 상태 저장 위젯 쌍으로 구성
상태 비저장 위젯은 Tween 들을 지정하고 Animation 객체를 정의하며
위젯 트리의 애니메이션 부분을 빌드하는 역할을 하는 build() 함수를 제공
상태 저장 위젯은 컨트롤러를 만들고, 애니메이션을 재생하고,
위젯 트리의 애니메이션이 아닌 부분을 빌드
화면의 아무 곳이나 탭이 감지되면 애니메이션이 시작됨

 */

class BasicStaggeredDemo extends StatefulWidget {
  const BasicStaggeredDemo({Key? key}) : super(key: key);

  @override
  _BasicStaggeredDemoState createState() => _BasicStaggeredDemoState();
}

/*
TickerMode:
위젯 하위 트리에서 티커(및 애니메이션 컨트롤러)를 활성화 또는 비활성화합니다.
이것은 AnimationController 객체를 생성한 경우에만 작동합니다.
(TickerProviderStateMixin, SingleTickerProviderStateMixin 을 사용)

TickerProviderStateMixin:
TickerMode 에 정의된 대로 현재 트리가 활성화된 동안에만 틱하도록 구성된
Ticker 개체를 제공합니다.
이 믹스인을 사용하는 클래스에서 AnimationController 를 만들려면
새 애니메이션 컨트롤러를 만들 때마다 vsync: this 를
애니메이션 컨트롤러 생성자에 전달합니다.
State 의 수명 동안 단일 Ticker(예: 단일 AnimationController)만
있는 경우 SingleTickerProviderStateMixin 을 사용하는 것이 더 효율적입니다.
이것은 일반적인 경우입니다.
 */
class _BasicStaggeredDemoState extends State<BasicStaggeredDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // 애니메이션이 취소되었습니다.
      // 아마도 우리가 폐기되었기 때문일 것입니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    // timeDilation = 10.0; // 1.0 is normal animation speed
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child: StaggerAnimation(controller: _controller.view),
          ),
        ),
      ),
    );
  }
}

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key? key, required this.controller})
      :
        // 여기에 정의된 각 애니메이션은 애니메이션 간격으로 정의된 컨트롤러
        // 지속 시간의 하위 집합 동안 값을 변환합니다.
        // 예를 들어 불투명도 애니메이션은 컨트롤러 지속 시간의
        // 처음 10% 동안 값을 변환합니다.

        opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.125,
              0.250,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.250, 0.375, curve: Curves.ease),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.only(bottom: 16.0),
          end: const EdgeInsets.only(bottom: 75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.250, 0.375, curve: Curves.ease),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(4.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(0.500, 0.750, curve: Curves.ease),
          ),
        ),
        super(key: key);

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder 은 복합 애니메이션을 쉽게 만들 수 있는 위젯
    // 애니메이션은 틱마다 다시 빌드하기 때문에
    // 내용물 자체는 바깥에서 렌더링이된(바깥 렌더트리의) 위젯을
    // 가져다 쓰는것이 성능에 굉장히 좋다.
    return AnimatedBuilder(animation: controller, builder: _buildAnimation);
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: width.value,
        height: height.value,
        decoration: BoxDecoration(
            color: color.value,
            border: Border.all(
              color: Colors.indigo[300]!,
              width: 3.0,
            ),
            borderRadius: borderRadius.value),
      ),
    );
  }
}
