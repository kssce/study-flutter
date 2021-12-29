/*
assets 변형을 지원한다.
 graphics/background.png 를 pubspec.yaml 에 지정했으면
 graphics/dark/background.png 도 변형 자산으로 간주하고 이 파일도 지원
 즉 지정경로/**/파일 를 변형으로 인정하는 것 같다.

rootBundle 보다는 BuildContext 에서 DefaultAssetBundle 을 사용해서 얻는 것이 좋다.
앱과 함께 빌드된 기본 자산 번들 대신 이 접근 방식을 사용하면 상위 위젯이
런타임에 다른 AssetBundle 을 대체할 수 있으므로 현지화 또는 테스트 시나리오에 유용할 수 있습니다.
해상도 장치 비율이 1.8인 것은 .../2.0x/my_icon.png 가 선택되고
해상도 장치 비율이 2.7인 것은 .../3.0x/my_icon.png 가 선택된다. (더 높은 해상도 사용)
해상도는 픽셀 크기이다. 1배 (72x72px) -> 3배 (216x216px)
이미지 로딩은 AssetImage('경로')를 사용
단, 자동이 아니라 pubspec 에다가 icons/heart.png, icons/1.5x/heart.png 이런 식으로
지정해야 한다

앱아이콘은 android 는 /android/../res 디렉토리에서 launch.png 전부교체 하면 됨
ios 는 ios/Runner/Assets.xcassets/AppIcon.appiconset 폴더를 통채로 교체하면 됨
안드로이드, ios 둘 다 가장 큰 한 이미지로 전체 이미지들 만드는 프로그램(웹) 돌려서 파일
추출해서 적용하면 됨 (RN도 이와 같았음)

스플래시 화면도 RN 과 동일하게 직접 해주면 됨
공식 문서 (https://docs.flutter.dev/development/ui/assets-and-images)에
언급은 하고 있음
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssetsAndImages extends StatelessWidget {
  const AssetsAndImages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'assets and images',
        home: Scaffold(
          appBar: AppBar(title: const Text("Assets and images")),
          body: MyButton(),
        )
    );
  }
}

class MyButton extends StatelessWidget {
  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
  }

  void _onPressed() {
    _loadAsset().then(print);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(onPressed: _onPressed, child: const Text("look console")),
        Image.asset(
            'assets/images/cat2.png', width: 600,
            height: 240,
            fit: BoxFit.cover)
      ],
    );
  }
}
