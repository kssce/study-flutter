import 'package:flutter/material.dart';

// 트윈 애니메이션은 처음과 끝을 지정하여 사용하는 방식의 애니메이션
// 범위: 0.0 ~ 1.0
// 효과를 위한 상태 없이 구현할 수 있다.
// 중간 프레임은 지정할 수 없으나 Curved 로 빌트인된 효과를 이용하면
// 중간에 다른 느낌을 줄 수 있다.
// Tween 객체의 인스턴스 생성시 begin 이 시작점이 되고 end 가 끝점이 된다.
// 생성해놓은 애니메이션을 실행시키기 위해 AnimationController 가 필요하다.
// 이는 애니메이션을 제어하기 위한 클래스이다.
// 인스턴스 생성시 애니메이션 동작 duration 과 vsync 를 프로퍼티로 받는데,
// vsync 는 TickerProvider 를 구현한 객체를 받도록 되어 있다.
// (vsync: 오프스크린 애니메이션이 불필요한 리소스를 소비하는 것을 방지)
// 이 때는 간단하게 with TickerProviderStateMixin 을 추가해주면
// 객체가 TickerProvider 가 되기 때문에 this 로 넘겨줄 수 있게 된다

class TweenContainer extends StatelessWidget {
  const TweenContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tween Container'),
        ),
        body: const SunContainer());
  }
}

class SunContainer extends StatefulWidget {
  const SunContainer({Key? key}) : super(key: key);

  @override
  _SunContainerState createState() => _SunContainerState();
}

class _SunContainerState extends State<SunContainer>
    with TickerProviderStateMixin {
  late ColorTween _colorTween;
  late Tween<Offset> _positionOffsetTween;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _render();
  }

  @override
  void didUpdateWidget(covariant SunContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _render();
  }

  @override
  void dispose() {
    // 중단
    _animationController.dispose();
    super.dispose();
  }

  void _render() {
    _colorTween = ColorTween(
      begin: Colors.yellow[300],
      end: Colors.red[300],
    );

    _positionOffsetTween = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    );

    // 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // 실행
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: _positionOffsetTween.animate(
          _animationController.drive(
            CurveTween(curve: Curves.bounceOut),
          ),
        ),
        child: Sun(animation: _colorTween.animate(_animationController)));
  }
}

// AnimatedWidget 을 상속받도록 수정하였다.
// AnimatedWidget 을 상속하면 listenable 객체를 생성자로 넣어줘야 하는데, 색상을 변경하기 위해 Animation<Color> 를 받도록 하였다.
// animation.value 로 프레임마다 계산된 컬러값을 받아와서 변경되도록 하였다.
class Sun extends AnimatedWidget {
  final Animation<Color?> animation;

  const Sun({Key? key, required this.animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    var maxWidth = MediaQuery.of(context).size.width;
    var margin = (maxWidth * .3) / 2;

    return Center(
      // 종횡비 위젯
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: animation.value),
        ),
      ),
    );
  }
}
