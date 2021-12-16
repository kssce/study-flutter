import 'package:flutter/material.dart';

/*
Staggered 애니메이션은 순차 또는 겹치는 애니메이션으로 구성됨
따라서 여러 Animation 객체를 사용한
하나의 AnimationController 는 모든 Animation 을 제어
각 Animation 객체는 Interval 동안 애니메이션을 지정
애니메이션되는 각 속성에 대해 트윈을 생성함

이 애니메이션은 한번에 모두가 아니라 일련의 작업으로 발생한다.
순차적이거나 부분적으로 혹은 완전히 겹칠 수 있으며, 변경 사항이
발생하지 않는 간격이 있을 수 있다.
 */

class BasicStaggeredDemo extends StatelessWidget {
  const BasicStaggeredDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
