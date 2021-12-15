import 'package:flutter/material.dart';

/*
Hero 는 화면 사이를 날아다니는 위젯을 의미
(날아다니는: 소스 route 에서 목적지 route 로 날아가면서 모양이 변함)
Hero 애니메이션은 두 개(소스, 대상)의 Hero 위젯을 사용해 구현

[ 중요 포인트 ]
- 서로 다른 route 에서 두 개의 영웅 위젯을 사용하지만 일치하는 태그를 가지고 애니메이션을 구현
- Navigator 는 앱의 route 가 포함된 스택 관리
- Navigator 스택에서 route 를 푸시하거나 팝업하면 애니메이션 트리거됨
- 플러터는 원본에서 대상 route 로 이동할때 RectTween 을 계산한다.
  계산되는 동안 두 route 는 오버레이처리되어 나타난다.

[ 구조 ]
1. source hero 라고 하는 시작 Hero 위젯 정의
   그래픽 표현(예: 이미지), 식별 태그를 지정
2. destination hero 라고 하는 종료 Hero 위젯 정의
   그래픽 표현, 동일한 태그를 지정(중요)
3. destination hero 를 포함하는 route 생성.
   대상 route 는 애니메이션 끝에 존재하는 위젯 트리를 정의
4. 네비게이터 스택에서 해당 route 를 push 하여 애니메이션 트리거
   네비게이터 push/pop 작업은 대상 route 에서 태그가 일치하는
   각 hero 쌍에 대해 hero 애니메이션을 트리거한다.
5. Flutter 는 시작점에서 끝점까지 Hero 의 경계를 애니메이션하는
   트윈을 계산하고(크기 및 위치를 보간) 오버레이에서 애니메이션을 수행

[ 필수 클래스 ]
- Hero: 출발지에서 목적지 route 로 날아기는 위젯으로, 두 위젯은
태그가 일치해야 함
- Inkwell: Hero 를 탭할 때 일어나는 일을 지정합니다.
InkWell 의 onTap() 메서드는 새 route 를 만들고 이를 네비게이터의 스택으로 푸시
- Navigator: route 의 스택 관리. push/pop 시 애니메이션 트리거
- Route: 화면이나 페이지 지정

MaterialPageRoute 혹은 CupertinoPageRoute 를 사용하여 Route 를 빌드한다.
대상 이미지는 SizedBox 로 래핑
 */

class HeroAnimation extends StatelessWidget {
  const HeroAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // timeDilation = 5.0; // 1.0 means normal animation speed.

    return Scaffold(
        appBar: AppBar(
          title: const Text('Basic Hero Animation'),
        ),
        body: Center(
            child: PhotoHero(
                photo: 'assets/images/cat1.png',
                width: 300.0,
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                    return Scaffold(
                        appBar: AppBar(
                          title: const Text('Flippers Page'),
                        ),
                        body: Container(
                            color: Colors.lightBlueAccent,
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.topLeft,
                            child: PhotoHero(
                                photo: 'assets/images/cat1.png',
                                width: 100.0,
                                onTap: () {
                                  Navigator.of(context).pop();
                                })));
                  }));
                })));
  }
}

class PhotoHero extends StatelessWidget {
  const PhotoHero(
      {Key? key, required this.photo, required this.onTap, required this.width})
      : super(key: key);

  final String photo;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(
              photo,
              // 화면 비율을 변경하지 않고 전환하는 동안 이미지가 최대한 크게 됨
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
