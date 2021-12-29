/*
constraints 는 최소 너비, 최대 너비, 최소 높이, 최대 높이로 구성되며,
크기는 특정 너비와 높이로 구성됨
가능한 최대 크기로 하고 싶은 경우. 예를 들어, Center 및 ListView 에서 사용하는 박스들이 있습니다.
자식 요소들과 같은 크기로 만들려는 경우. 예를 들어, Transform 및 Opacity 에서 사용하는 박스들이 있습니다.
개별적인 크기를 갖게 하려는 경우. 예를 들어, Image 및 Text 에서 사용하는 박스들이 있습니다.

Unbounded constraints 는 최대 너비나 최대 높이가 double.INFINITY 인 것으로,
ListView 및 다른 ScrollView 의 하위 클래스 내부에 적용된다.
또한 플렉스 박스(Row, Column)의 내부도 마찬가지.

어떤 위젯은 width: 100의 값이 적용되지 않는 모습을 볼 수 있습니다.
이 문제의 일반적인 답변은 Center 위젯을 이용하라는 것입니다.
하지만 위와 같은 방식은 모든 것을 해결할 수 없습니다.
플러터는 일반적인 HTML 의 레이아웃과 다릅니다.
플러터의 레이아웃은 아래와 같은 규칙을 따릅니다.
Constraints go down. Sizes go up. Parent sets Position
(제약 조건은 부모에서 자식으로 흐르고, 크기는 자식이 부모에게 제안한다. (부모의 제약 조건 안에서)
부모가 위치를 정의한다.)

위젯은 자신의 size 를 오직 부모로부터 받은 Constraints 에 의해서만 결정할 수 있습니다.
이것은 위젯 스스로 어떠한 사이즈도 결정할 수 없다는 뜻입니다.
위젯의 위치를 결정하는 건 부모이기 때문에 위젯은 자신의 위치를 결정하지 못합니다.
부모의 크기와 위치도 역시 자신의 부모에 의존하기 때문에
전체 위젯 트리를 고려하지 않고 위젯의 크기와 위치를
정확하게 정의하는 것은 불가능합니다. (그야말로 반응형)
부모가 충분한 정보를 제공 받지 않은 상태에서 자식의 사이즈를 다르게 하는것은 무시됩니다.
그러므로 구체적으로 정렬을 정의하는 것이 중요합니다.

[ 렌더링 순서 ]
모든 위젯은 부모로부터 고유한 constraints 를 받는다. (최대 너비, 최소 너비 최대 높이, 최소 높이)
부모 위젯은 각 자식에게 자신의 제약조건이 무엇인지 알려주고, 각 자식에게 원하는 크기를 묻는다.
그 다음 자식을 x, y 축으로 하나씩 배치한다.
마지막으로 위젯은 부모에게 자체 크기를 알려준다.

[ 중요 제약사항 ]
위젯은 부모가 지정한 제약 조건 내에서만 자체 크기를 결정할 수 있다.
이는 원하는 크기를 가질 수 없다는 것을 의미
위젯의 위치를 결정하는 것은 부모이기 때문에
스스로 스크린에서의 위치를 알지도 못하며 결정하지도 못한다.
자식이 부모와 다른 크기를 원하고 부모가 이를 정렬할 정보가 충분하지 않은 경우
자식의 크기는 무시될 수 있다. 정렬을 정의할 때는 구체적이어야 한다.

[ 주요 위젯 ]
FittedBox: 자식이나 내용물에 따라 크기가 확장되는 위젯에 의해 오버플로우가 발생하는 경우
이것으로 감싸면 디바이스 사이즈를 넘지 않게되며 오버플로우가 방지됨
가로 방향으로 확장되는 위젯이라면, 그 부모가 컬럼인 경우 width 는 기기 또는 부모 사이즈에
한정되므로 FittedBox 로 감싸면 width 에 맞춰 줄어들지만, 부모가 로우인 경우는
로우는 가로 방향으로 무한대의 width 를 허락하므로 FittedBox 로 감싸도 아무
영향도 주지 않음
로우를 FittedBox 로 감싸면 메인 엑시스인 가로 방향으로 축소시키고,
컬럼을 감싸면 세로 방향으로 축소시킴

BoxConstraints:
BoxConstraints.tight: 해당 제약조건의 최대 너비는 최소 너비와 같고,
  해당 제약 조건의 최대 높이는 최소 높이와 같다.
  제약 조건을 입력하지 않는 경우 해당 min 값들은 0이 되고 max 값들은 무한이 된다.
  이 제약 조건은 가능한 정확한 크기를 제공한다.
BoxConstraints.loose: min 값들은 0, max 값들은 지정한 너비와 높이와 같다.
BoxConstraints 자체는 지정한 제약조건을 지정한다.
주로 ConstrainedBox 의 constraints 속성 지정에 사용된다.

ConstrainedBox:
너비와 높이와 위치는 부모의 제약조건에 달려있지만
그럼에도 너비와 높이를 조정하고 싶을 때 사용한다.
이를 이용해 자식 위젯의 넓이와 높이의 최대 및 최솟값을 설정할 수 있다.
부모로부터 받은 제약 조건에서만 추가 제약을 부과할 수 있다.
즉, 부모의 제약조건 내에서 추가 제약을 걸때 사용
Center 로 감싸면 ConstrainedBox 가 화면 크기까지 모든 크기가 될 수 있고,
자식은 부모의 제약 조건 안에서 추가 제약 조건 걸 수 있음
자식이 제시한 제약조건이 너무 큰 경우 최대 제약조건으로 적용되고
너무 작은 경우 최소 제약조건으로 적용됨

UnconstrainedBox:
자신은 부모와 제약 조건과 똑같이 만들고 자식은 제약조건과 무관하게 레이아웃할 수 있다.
단, 무한을 지정하는 경우 에러와 함께 렌더링되지 않음

Row:
화면은 Row 가 화면과 정확히 같은 크기가 되도록 합니다.
UnconstrainedBox 와 마찬가지로 Row 는 자식에게 제약을 부과하지 않고
대신 원하는 크기로 허용합니다. 그런 다음 Row 는 이들을 나란히 놓고
추가 공간은 비어 있습니다.

Expanded:
Row 의 자식이 Expanded 위젯에 래핑되면 Row 는 이 자식이 더 이상 자신의 너비를
정의하도록 하지 않습니다.
대신, Expanded 위젯은 다른 자식에 따라 Expanded 너비를 정의하고
그 다음에야 Expanded 위젯이 원래 자식에게 Expanded 의 너비입니다.
즉, Expanded 를 사용하면 원래 자식의 너비가 무의미해지고 무시됩니다.

Scaffold:
화면은 Scaffold 가 화면과 정확히 같은 크기가 되도록 강제하므로
Scaffold 가 화면을 채웁니다.
Scaffold 는 Container 에게 원하는 크기가 될 수 있지만
화면보다 크지는 않다고 알려줍니다. (Center, Align 과 같은 특징)
Scaffold 의 자식이 Scaffold 자체와 정확히 같은 크기가 되도록 하려면
자식을 SizedBox.expand 로 래핑할 수 있습니다.
 */
import 'package:flutter/material.dart';

class MyBoxConstraints extends StatelessWidget {
  const MyBoxConstraints({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "box constraints",
        home: Scaffold(
          appBar: AppBar(title: const Text("Box Constraints")),
          body: const _HomePage(),
        ));
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FlutterLayoutArticle([
      Example1(),
      Example2(),
      Example3(),
      Example4(),
      Example5(),
      Example6(),
      Example7(),
      Example8(),
      Example9(),
      Example10(),
      Example11(),
      Example12(),
      Example13(),
      Example14(),
      Example15(),
      Example16(),
      Example17(),
      Example18(),
      Example19(),
      Example20(),
      Example21(),
      Example22(),
      Example23(),
      Example24(),
      Example25(),
      Example26(),
      Example27(),
      Example28(),
      Example29(),
    ]);
  }
}

//////////////////////////////////////////////////

abstract class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  String get code;

  String get explanation;
}

//////////////////////////////////////////////////

class FlutterLayoutArticle extends StatefulWidget {
  const FlutterLayoutArticle(
    this.examples, {
    Key? key,
  }) : super(key: key);

  final List<Example> examples;

  @override
  _FlutterLayoutArticleState createState() => _FlutterLayoutArticleState();
}

//////////////////////////////////////////////////

class _FlutterLayoutArticleState extends State<FlutterLayoutArticle> {
  late int count;
  late Widget example;
  late String code;
  late String explanation;

  @override
  void initState() {
    count = 1;
    code = const Example1().code;
    explanation = const Example1().explanation;

    super.initState();
  }

  @override
  void didUpdateWidget(FlutterLayoutArticle oldWidget) {
    super.didUpdateWidget(oldWidget);
    var example = widget.examples[count - 1];
    code = example.code;
    explanation = example.explanation;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Layout Article',
      home: SafeArea(
        child: Material(
          color: Colors.black,
          child: FittedBox(
            child: Container(
              width: 400,
              height: 670,
              color: const Color(0xFFCCCCCC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      // 박스
                      child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: double.infinity, height: double.infinity),
                          child: widget.examples[count - 1])),
                  Container(
                    // 버튼
                    height: 50,
                    width: double.infinity,
                    color: Colors.black,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (int i = 0; i < widget.examples.length; i++)
                            Container(
                              width: 58,
                              padding:
                                  const EdgeInsets.only(left: 4.0, right: 4.0),
                              child: button(i + 1),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    // 설명
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        key: ValueKey(count),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              Center(child: Text(code)),
                              const SizedBox(height: 15),
                              Text(
                                explanation,
                                style: TextStyle(
                                    color: Colors.blue[900],
                                    fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    height: 273,
                    color: Colors.grey[50],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget button(int exampleNumber) {
    return Button(
      key: ValueKey('button$exampleNumber'),
      isSelected: count == exampleNumber,
      exampleNumber: exampleNumber,
      onPressed: () {
        showExample(
          exampleNumber,
          widget.examples[exampleNumber - 1].code,
          widget.examples[exampleNumber - 1].explanation,
        );
      },
    );
  }

  void showExample(int exampleNumber, String code, String explanation) {
    setState(() {
      count = exampleNumber;
      this.code = code;
      this.explanation = explanation;
    });
  }
}

//////////////////////////////////////////////////

class Button extends StatelessWidget {
  final bool isSelected;
  final int exampleNumber;
  final VoidCallback onPressed;

  const Button({
    required Key key,
    required this.isSelected,
    required this.exampleNumber,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: isSelected ? Colors.grey : Colors.grey[800],
      ),
      child: Text(exampleNumber.toString()),
      onPressed: () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          alignment: 0.5,
        );
        onPressed();
      },
    );
  }
}

//////////////////////////////////////////////////
const red = Colors.red;
const green = Colors.green;
const blue = Colors.blue;
const big = TextStyle(fontSize: 30);

class Example1 extends Example {
  const Example1({Key? key}) : super(key: key);

  @override
  final code = 'Container(color: red)';

  @override
  final explanation = 'The screen is the parent of the Container, '
      'and it forces the Container to be exactly the same size as the screen.'
      '\n\n'
      'So the Container fills the screen and paints it red.';

  @override
  Widget build(BuildContext context) {
    return Container(color: red);
  }
}

//////////////////////////////////////////////////

class Example2 extends Example {
  const Example2({Key? key}) : super(key: key);

  @override
  final code = 'Container(width: 100, height: 100, color: red)';
  @override
  final String explanation =
      'The red Container wants to be 100x100, but it can\'t, '
      'because the screen forces it to be exactly the same size as the screen.'
      '\n\n'
      'So the Container fills the screen.';

  @override
  Widget build(BuildContext context) {
    // 부모의 제약 조건의 min max 가 모두 무한이므로
    // 자식의 이 사이즈는 무시된다. (부모 제약조건 범위에 들어가지 않으므로)
    return Container(width: 100, height: 100, color: red);
  }
}

//////////////////////////////////////////////////

class Example3 extends Example {
  const Example3({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: Container(width: 100, height: 100, color: red))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen,'
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      'Now the Container can indeed be 100x100.';

  @override
  Widget build(BuildContext context) {
    // 화면은 Center 가 화면과 정확히 같은 크기가 되도록 강제하므로 Center 가 화면을 채웁니다.
    // Center 는 Container 에게 원하는 크기가 될 수 있지만 화면보다 크지 않다고 알려줍니다.
    // 이제 컨테이너는 실제로 100 × 100이 될 수 있습니다.
    return Center(
      child: Container(width: 100, height: 100, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example4 extends Example {
  const Example4({Key? key}) : super(key: key);

  @override
  final code = 'Align(\n'
      '   alignment: Alignment.bottomRight,\n'
      '   child: Container(width: 100, height: 100, color: red))';
  @override
  final String explanation =
      'This is different from the previous example in that it uses Align instead of Center.'
      '\n\n'
      'Align also tells the Container that it can be any size it wants, but if there is empty space it won\'t center the Container. '
      'Instead, it aligns the Container to the bottom-right of the available space.';

  @override
  Widget build(BuildContext context) {
    // 이것은 Center 대신 Align 을 사용한다는 점에서 이전 예제와 다릅니다.
    // 대신 컨테이너를 사용 가능한 공간의 오른쪽 아래에 맞춥니다.
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(width: 100, height: 100, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example5 extends Example {
  const Example5({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: Container(\n'
      '              color: red,\n'
      '              width: double.infinity,\n'
      '              height: double.infinity))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen,'
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      'The Container wants to be of infinite size, but since it can\'t be bigger than the screen, it just fills the screen.';

  @override
  Widget build(BuildContext context) {
    // 화면은 Center 가 화면과 정확히 같은 크기가 되도록 강제하므로 Center 가 화면을 채웁니다.
    // Center 는 Container 에게 원하는 크기가 될 수 있지만 화면보다 크지 않다고 알려줍니다.
    // Container 는 무한한 크기를 원하지만 화면보다 클 수 없기 때문에 화면을 채울 뿐입니다.
    return Center(
      child: Container(
          width: double.infinity, height: double.infinity, color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example6 extends Example {
  const Example6({Key? key}) : super(key: key);

  @override
  final code = 'Center(child: Container(color: red))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen,'
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the Container that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'Since the Container has no child and no fixed size, it decides it wants to be as big as possible, so it fills the whole screen.'
      '\n\n'
      'But why does the Container decide that? '
      'Simply because that\'s a design decision by those who created the Container widget. '
      'It could have been created differently, and you have to read the Container documentation to understand how it behaves, depending on the circumstances. ';

  @override
  Widget build(BuildContext context) {
    // 화면은 Center 가 화면과 정확히 같은 크기가 되도록 강제하므로 Center 가 화면을 채웁니다.
    // Center 는 Container 에게 원하는 크기가 될 수 있지만 화면보다 크지 않다고 알려줍니다.
    // Container 는 자식이 없고 고정된 크기가 없으므로
    // 최대한 크게 결정하여 전체 화면을 채웁니다.
    // 그런데 Container 는 왜 그렇게 결정할까요?
    // 컨테이너 위젯을 만든 사람들이 디자인 결정을 내린 것이기 때문입니다.
    // 다르게 생성되었을 수 있으며 상황에 따라 어떻게 동작하는지 이해하려면
    // 컨테이너 문서를 읽어야 합니다.
    return Center(
      child: Container(color: red),
    );
  }
}

//////////////////////////////////////////////////

class Example7 extends Example {
  const Example7({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: Container(color: red\n'
      '      child: Container(color: green, width: 30, height: 30)))';
  @override
  final String explanation =
      'The screen forces the Center to be exactly the same size as the screen,'
      'so the Center fills the screen.'
      '\n\n'
      'The Center tells the red Container that it can be any size it wants, but not bigger than the screen.'
      'Since the red Container has no size but has a child, it decides it wants to be the same size as its child.'
      '\n\n'
      'The red Container tells its child that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'The child is a green Container that wants to be 30x30.'
      '\n\n'
      'Since the red `Container` has no size but has a child, it decides it wants to be the same size as its child. '
      'The red color isn\'t visible, since the green Container entirely covers all of the red Container.';

  @override
  Widget build(BuildContext context) {
    // 화면은 Center 가 화면과 정확히 같은 크기가 되도록 강제하므로 Center 가 화면을 채웁니다.
    // Center 는 빨간색 컨테이너에 원하는 크기가 될 수 있지만 화면보다 크지 않다고 알려줍니다.
    // 빨간색 컨테이너는 크기가 없지만 [자식이 있으므로 자식과 같은 크기로 결정합니다.]
    // 빨간색 컨테이너는 자식에게 원하는 크기가 될 수 있지만 화면보다 크지 않음을 알려줍니다.
    // 자식은 30 × 30이 되고자 하는 녹색 Container.
    // 빨간색 Container 의 크기가 자식의 크기에 맞게 조정된다는 점을 감안할 때
    // 30 × 30이기도 합니다. 녹색 Container 가 빨간색 Container 를
    // 완전히 덮기 때문에 빨간색이 보이지 않습니다.
    return Center(
      child: Container(
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example8 extends Example {
  const Example8({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: Container(color: red\n'
      '      padding: const EdgeInsets.all(20.0),\n'
      '      child: Container(color: green, width: 30, height: 30)))';
  @override
  final String explanation =
      'The red Container sizes itself to its children size, but it takes its own padding into consideration. '
      'So it is also 30x30 plus padding. '
      'The red color is visible because of the padding, and the green Container has the same size as in the previous example.';

  @override
  Widget build(BuildContext context) {
    // 빨간색 컨테이너는 자식 크기에 맞게 자체 크기를 조정하지만 자체 패딩을 고려합니다.
    // 따라서 30 × 30 플러스 패딩입니다.
    // 패딩으로 인해 빨간색이 보이고 초록색 Container 는 앞의 예시와 같은 크기를 가지고 있습니다.
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        color: red,
        child: Container(color: green, width: 30, height: 30),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example9 extends Example {
  const Example9({Key? key}) : super(key: key);

  @override
  final code = 'ConstrainedBox(\n'
      '   constraints: BoxConstraints(\n'
      '              minWidth: 70, minHeight: 70,\n'
      '              maxWidth: 150, maxHeight: 150),\n'
      '      child: Container(color: red, width: 10, height: 10)))';
  @override
  final String explanation =
      'You might guess that the Container has to be between 70 and 150 pixels, but you would be wrong. '
      'The ConstrainedBox only imposes ADDITIONAL constraints from those it receives from its parent.'
      '\n\n'
      'Here, the screen forces the ConstrainedBox to be exactly the same size as the screen, '
      'so it tells its child Container to also assume the size of the screen, '
      'thus ignoring its \'constraints\' parameter.';

  @override
  Widget build(BuildContext context) {
    // 컨테이너가 70에서 150픽셀 사이여야 한다고 추측할 수 있지만 잘못된 것입니다.
    // ConstrainedBox 는 부모로부터 받은 제약 조건에서만 추가 제약을 부과합니다.
    // 여기에서 화면은 ConstrainedBox 가 화면과 정확히 같은 크기가 되도록 강제하므로
    // 자식 컨테이너도 화면 크기를 가정하도록 지시하여 제약 조건 매개변수를 무시합니다.
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 70,
        minHeight: 70,
        maxWidth: 150,
        maxHeight: 150,
      ),
      child: Container(color: red, width: 10, height: 10),
    );
  }
}

//////////////////////////////////////////////////

class Example10 extends Example {
  const Example10({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 10, height: 10))))';
  @override
  final String explanation =
      'Now, Center allows ConstrainedBox to be any size up to the screen size.'
      '\n\n'
      'The ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child.'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 10 pixels, so it will end up having 70 (the MINIMUM).';

  @override
  Widget build(BuildContext context) {
    // 이제 Center 에서는 ConstrainedBox 가 화면 크기까지 모든 크기가 될 수 있습니다.
    // ConstrainedBox 는 제약 조건 매개변수의 추가 제약 조건을 자식에 적용합니다.
    // 컨테이너는 70픽셀에서 150픽셀 사이여야 합니다.
    // 10픽셀을 원하므로 70(최소)이 됩니다.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 10, height: 10),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example11 extends Example {
  const Example11({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 1000, height: 1000))))';
  @override
  final String explanation =
      'Center allows ConstrainedBox to be any size up to the screen size.'
      'The ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 1000 pixels, so it ends up having 150 (the MAXIMUM).';

  @override
  Widget build(BuildContext context) {
    // Center 를 사용하면 ConstrainedBox 가 화면 크기까지 모든 크기가 될 수 있습니다.
    // ConstrainedBox 는 제약 조건 매개변수의 추가 제약 조건을 자식에 적용합니다.
    // 컨테이너는 70픽셀에서 150픽셀 사이여야 합니다.
    // 1000픽셀을 원하므로 150(최대)이 됩니다.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 1000, height: 1000),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example12 extends Example {
  const Example12({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: ConstrainedBox(\n'
      '      constraints: BoxConstraints(\n'
      '                 minWidth: 70, minHeight: 70,\n'
      '                 maxWidth: 150, maxHeight: 150),\n'
      '        child: Container(color: red, width: 100, height: 100))))';
  @override
  final String explanation =
      'Center allows ConstrainedBox to be any size up to the screen size.'
      'ConstrainedBox imposes ADDITIONAL constraints from its \'constraints\' parameter onto its child.'
      '\n\n'
      'The Container must be between 70 and 150 pixels. It wants to have 100 pixels, and that\'s the size it has, since that\'s between 70 and 150.';

  @override
  Widget build(BuildContext context) {
    // Center 를 사용하면 ConstrainedBox 가 화면 크기까지 모든 크기가 될 수 있습니다.
    // ConstrainedBox 는 제약 조건 매개변수의 추가 제약 조건을 자식에 적용합니다.
    // 컨테이너는 70픽셀에서 150픽셀 사이여야 합니다.
    // 100픽셀을 원하고 크기가 70에서 150 사이이기 때문입니다.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 70,
          minHeight: 70,
          maxWidth: 150,
          maxHeight: 150,
        ),
        child: Container(color: red, width: 100, height: 100),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example13 extends Example {
  const Example13({Key? key}) : super(key: key);

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: red, width: 20, height: 50));';
  @override
  final String explanation =
      'The screen forces the UnconstrainedBox to be exactly the same size as the screen.'
      'However, the UnconstrainedBox lets its child Container be any size it wants.';

  @override
  Widget build(BuildContext context) {
    // 화면은 UnconstrainedBox 가 화면과 정확히 같은 크기가 되도록 합니다.
    // 그러나 UnconstrainedBox 를 사용하면 자식 컨테이너를 원하는 크기로 지정할 수 있습니다.
    return UnconstrainedBox(
      child: Container(color: red, width: 20, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example14 extends Example {
  const Example14({Key? key}) : super(key: key);

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: red, width: 4000, height: 50));';
  @override
  final String explanation =
      'The screen forces the UnconstrainedBox to be exactly the same size as the screen, '
      'and UnconstrainedBox lets its child Container be any size it wants.'
      '\n\n'
      'Unfortunately, in this case the Container has 4000 pixels of width and is too big to fit in the UnconstrainedBox, '
      'so the UnconstrainedBox displays the much dreaded "overflow warning".';

  @override
  Widget build(BuildContext context) {
    // 화면은 UnconstrainedBox 가 화면과 정확히 같은 크기가 되도록 강제하고
    // UnconstrainedBox 는 자식 Container 가 원하는 크기가 되도록 합니다.
    // 불행히도 이 경우 Container 의 너비는 4000픽셀이고 너무 커서
    // UnconstrainedBox 에 맞지 않습니다.
    // UnconstrainedBox 는 두려운 "오버플로 경고"를 표시합니다.
    return UnconstrainedBox(
      child: Container(color: red, width: 4000, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example15 extends Example {
  const Example15({Key? key}) : super(key: key);

  @override
  final code = 'OverflowBox(\n'
      '   minWidth: 0.0,'
      '   minHeight: 0.0,'
      '   maxWidth: double.infinity,'
      '   maxHeight: double.infinity,'
      '   child: Container(color: red, width: 4000, height: 50));';
  @override
  final String explanation =
      'The screen forces the OverflowBox to be exactly the same size as the screen, '
      'and OverflowBox lets its child Container be any size it wants.'
      '\n\n'
      'OverflowBox is similar to UnconstrainedBox, and the difference is that it won\'t display any warnings if the child doesn\'t fit the space.'
      '\n\n'
      'In this case the Container is 4000 pixels wide, and is too big to fit in the OverflowBox, '
      'but the OverflowBox simply shows as much as it can, with no warnings given.';

  @override
  Widget build(BuildContext context) {
    // 화면은 OverflowBox 가 화면과 정확히 같은 크기가 되도록 강제하고
    // OverflowBox 는 자식 컨테이너가 원하는 크기가 되도록 합니다.
    // OverflowBox 는 UnconstrainedBox 와 유사합니다.
    // 차이점은 자식이 공간에 맞지 않으면 경고를 표시하지 않는다는 것입니다.
    // 이 경우 컨테이너의 너비는 4000픽셀이고 너무 커서 OverflowBox 에 맞지 않지만
    // OverflowBox 는 단순히 가능한 한 경고가 표시되지 않습니다.
    // [경고는 표시하지 않지만 실제로 화면 넘어까지 렌더링을 함]
    return OverflowBox(
      minWidth: 0.0,
      minHeight: 0.0,
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      child: Container(color: red, width: 4000, height: 50),
    );
  }
}

//////////////////////////////////////////////////

class Example16 extends Example {
  const Example16({Key? key}) : super(key: key);

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: Container(color: Colors.red, width: double.infinity, height: 100));';
  @override
  final String explanation =
      'This won\'t render anything, and you\'ll see an error in the console.'
      '\n\n'
      'The UnconstrainedBox lets its child be any size it wants, '
      'however its child is a Container with infinite size.'
      '\n\n'
      'Flutter can\'t render infinite sizes, so it throws an error with the following message: '
      '"BoxConstraints forces an infinite width."';

  @override
  Widget build(BuildContext context) {
    // 이것은 아무 것도 렌더링하지 않으며 콘솔에 오류가 표시됩니다.
    // UnconstrainedBox 는 자식을 원하는 크기로 만들 수 있지만
    // 자식은 무한 크기의 컨테이너입니다. Flutter 는 무한 크기를 렌더링할 수 없으므로
    // 에러를 던집니다. 메시지와 함께 오류가 발생했습니다.
    // BoxConstraints 는 무한한 너비를 강제합니다.
    return UnconstrainedBox(
      child: Container(color: Colors.red, width: double.infinity, height: 100),
    );
  }
}

//////////////////////////////////////////////////

class Example17 extends Example {
  const Example17({Key? key}) : super(key: key);

  @override
  final code = 'UnconstrainedBox(\n'
      '   child: LimitedBox(maxWidth: 100,\n'
      '      child: Container(color: Colors.red,\n'
      '                       width: double.infinity, height: 100));';
  @override
  final String explanation = 'Here you won\'t get an error anymore, '
      'because when the LimitedBox is given an infinite size by the UnconstrainedBox, '
      'it passes a maximum width of 100 down to its child.'
      '\n\n'
      'If you swap the UnconstrainedBox for a Center widget, '
      'the LimitedBox won\'t apply its limit anymore (since its limit is only applied when it gets infinite constraints), '
      'and the width of the Container is allowed to grow past 100.'
      '\n\n'
      'This explains the difference between a LimitedBox and a ConstrainedBox.';

  @override
  Widget build(BuildContext context) {
    // LimitedBox 와 UnconstrainedBox 에 의해 무한한 크기가 주어지기 때문에
    // 여기서 더 이상 오류가 발생하지 않습니다. 최대 너비 100을 자식에게 전달합니다.
    // UnconstrainedBox 를 Center 위젯으로 바꾸면
    // LimitedBox 는 더 이상 제한(maxWidth)을 적용하지 않습니다
    // (LimitedBox 는 제한이 무한 제약 조건을 받을 때만 적용되기 때문에).
    // 컨테이너는 100을 초과하여 성장할 수 있습니다.
    // 이것은 LimitedBox 와 ConstrainedBox 의 차이점을 설명합니다.
    return UnconstrainedBox(
      child: LimitedBox(
        maxWidth: 100,
        child: Container(
          color: Colors.red,
          width: double.infinity,
          height: 100,
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example18 extends Example {
  const Example18({Key? key}) : super(key: key);

  @override
  final code = 'FittedBox(\n'
      '   child: Text(\'Some Example Text.\'));';
  @override
  final String explanation =
      'The screen forces the FittedBox to be exactly the same size as the screen.'
      'The Text has some natural width (also called its intrinsic width) that depends on the amount of text, its font size, and so on.'
      '\n\n'
      'The FittedBox lets the Text be any size it wants, '
      'but after the Text tells its size to the FittedBox, '
      'the FittedBox scales the Text until it fills all of the available width.';

  @override
  Widget build(BuildContext context) {
    // 화면은 FittedBox 가 화면과 정확히 같은 크기가 되도록 합니다.
    // 텍스트에는 텍스트의 양, 글꼴 크기 등에 따라 달라지는
    // 자연스러운 너비(내재 너비라고도 함)가 있습니다.
    // FittedBox 는 사용 가능한 모든 너비를 채울 때까지 텍스트의 크기를 조정합니다.
    return const FittedBox(
      child: Text('Some Example Text.'),
    );
  }
}

//////////////////////////////////////////////////

class Example19 extends Example {
  const Example19({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: FittedBox(\n'
      '      child: Text(\'Some Example Text.\')));';
  @override
  final String explanation =
      'But what happens if you put the FittedBox inside of a Center widget? '
      'The Center lets the FittedBox be any size it wants, up to the screen size.'
      '\n\n'
      'The FittedBox then sizes itself to the Text, and lets the Text be any size it wants.'
      '\n\n'
      'Since both FittedBox and the Text have the same size, no scaling happens.';

  @override
  Widget build(BuildContext context) {
    // 그러나 Center 위젯 안에 FittedBox 를 넣으면 어떻게 될까요?
    // Center 는 FittedBox 가 화면 크기까지 원하는 크기가 되도록 합니다.
    // 그런 다음 FittedBox 는 Text 에 맞게 크기를 조정하고
    // Text 를 원하는 크기로 만듭니다.
    // FittedBox 와 Text 의 크기가 모두 같기 때문에 크기 조정이 발생하지 않습니다.
    return const Center(
      child: FittedBox(
        child: Text('Some Example Text.'),
      ),
    );
  }
}

////////////////////////////////////////////////////

class Example20 extends Example {
  const Example20({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: FittedBox(\n'
      '      child: Text(\'…\')));';
  @override
  final String explanation =
      'However, what happens if FittedBox is inside of a Center widget, but the Text is too large to fit the screen?'
      '\n\n'
      'FittedBox tries to size itself to the Text, but it can\'t be bigger than the screen. '
      'It then assumes the screen size, and resizes Text so that it fits the screen, too.';

  @override
  Widget build(BuildContext context) {
    // 그러나 FittedBox 가 Center 위젯 내부에 있지만
    // 텍스트가 너무 커서 화면에 맞지 않으면 어떻게 됩니까?
    // FittedBox 는 텍스트에 맞게 크기를 조정하려고 하지만 화면보다 클 수는 없습니다.
    // 그런 다음 화면 크기를 가정하고 화면에 맞도록 텍스트 크기도 조정합니다.
    return const Center(
      child: FittedBox(
        child: Text(
            'This is some very very very large text that is too big to fit a regular screen in a single line.'),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example21 extends Example {
  const Example21({Key? key}) : super(key: key);

  @override
  final code = 'Center(\n'
      '   child: Text(\'…\'));';
  @override
  final String explanation = 'If, however, you remove the FittedBox, '
      'the Text gets its maximum width from the screen, '
      'and breaks the line so that it fits the screen.';

  @override
  Widget build(BuildContext context) {
    // 그러나 FittedBox 를 제거하면 텍스트가 화면에서 최대 너비를 가져오고
    // 화면에 맞도록 줄을 나눕니다.
    return const Center(
      child: Text(
          'This is some very very very large text that is too big to fit a regular screen in a single line.'),
    );
  }
}

//////////////////////////////////////////////////

class Example22 extends Example {
  const Example22({Key? key}) : super(key: key);

  @override
  final code = 'FittedBox(\n'
      '   child: Container(\n'
      '      height: 20.0, width: double.infinity));';
  @override
  final String explanation =
      'FittedBox can only scale a widget that is BOUNDED (has non-infinite width and height).'
      'Otherwise, it won\'t render anything, and you\'ll see an error in the console.';

  @override
  Widget build(BuildContext context) {
    // FittedBox 는 경계가 있는 위젯만 크기를 조정할 수 있습니다
    // (경계가 있는 위젯 = 폭과 높이 리터럴을 가짐(무한하지 않음)).
    // 그렇지 않으면 아무 것도 렌더링되지 않으며 콘솔에 오류가 표시됩니다.
    return FittedBox(
      child: Container(
        height: 20.0,
        width: double.infinity,
        color: Colors.red,
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example23 extends Example {
  const Example23({Key? key}) : super(key: key);

  @override
  final code = 'Row(children:[\n'
      '   Container(color: red, child: Text(\'Hello!\'))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'The screen forces the Row to be exactly the same size as the screen.'
      '\n\n'
      'Just like an UnconstrainedBox, the Row won\'t impose any constraints onto its children, '
      'and instead lets them be any size they want.'
      '\n\n'
      'The Row then puts them side-by-side, and any extra space remains empty.';

  @override
  Widget build(BuildContext context) {
    // 화면은 Row 가 화면과 정확히 같은 크기가 되도록 합니다.
    // UnconstrainedBox 와 마찬가지로 Row 는 자식에게 제약을 부과하지 않고
    // 대신 원하는 크기로 허용합니다. 그런 다음 Row 는 이들을 나란히 놓고
    // 추가 공간은 비어 있습니다.
    return Row(
      children: [
        Container(color: red, child: const Text('Hello!', style: big)),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example24 extends Example {
  const Example24({Key? key}) : super(key: key);

  @override
  final code = 'Row(children:[\n'
      '   Container(color: red, child: Text(\'…\'))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'Since the Row won\'t impose any constraints onto its children, '
      'it\'s quite possible that the children might be too big to fit the available width of the Row.'
      'In this case, just like an UnconstrainedBox, the Row displays the "overflow warning".';

  @override
  Widget build(BuildContext context) {
    // Row 는 자식에게 제약을 가하지 않기 때문에 자식이 너무 커서 Row 의 사용 가능한
    // 너비에 맞지 않을 수 있습니다.
    // 이 경우 UnconstrainedBox 와 마찬가지로 Row 에 "오버플로 경고"가 표시됩니다.
    return Row(
      children: [
        Container(
          color: red,
          child: const Text(
            'This is a very long text that '
            'won\'t fit the line.',
            style: big,
          ),
        ),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example25 extends Example {
  const Example25({Key? key}) : super(key: key);

  @override
  final code = 'Row(children:[\n'
      '   Expanded(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'When a Row\'s child is wrapped in an Expanded widget, the Row won\'t let this child define its own width anymore.'
      '\n\n'
      'Instead, it defines the Expanded width according to the other children, and only then the Expanded widget forces the original child to have the Expanded\'s width.'
      '\n\n'
      'In other words, once you use Expanded, the original child\'s width becomes irrelevant, and is ignored.';

  @override
  Widget build(BuildContext context) {
    // Row 의 자식이 Expanded 위젯에 래핑되면 Row 는 이 자식이 더 이상 자신의 너비를
    // 정의하도록 하지 않습니다.
    // 대신, Expanded 위젯은 다른 자식에 따라 Expanded 너비를 정의하고
    // 그 다음에야 Expanded 위젯이 원래 자식에게 Expanded 의 너비입니다.
    // 즉, Expanded 를 사용하면 원래 자식의 너비가 무의미해지고 무시됩니다.
    return Row(
      children: [
        Expanded( // Expanded 는 자식이 너비를 정의하지 않게함
          child: Center(
            child: Container(
              color: red,
              child: const Text(
                'This is a very long text that won\'t fit the line.',
                style: big,
              ),
            ),
          ),
        ),
        Container(color: green, child: const Text('Goodbye!', style: big)),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example26 extends Example {
  const Example26({Key? key}) : super(key: key);

  @override
  final code = 'Row(children:[\n'
      '   Expanded(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Expanded(\n'
      '       child: Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'If all of Row\'s children are wrapped in Expanded widgets, each Expanded has a size proportional to its flex parameter, '
      'and only then each Expanded widget forces its child to have the Expanded\'s width.'
      '\n\n'
      'In other words, Expanded ignores the preffered width of its children.';

  @override
  Widget build(BuildContext context) {
    // Row 의 모든 자식이 Expanded 위젯으로 래핑된 경우 Expanded 각각은
    // flex 매개변수에 비례하는 크기를 가지며 각 Expanded 위젯은
    // 자식이 Expanded 의 너비를 갖도록 강제합니다.
    // 즉, Expanded 는 자식의 기본 너비를 무시합니다.
    return Row(
      children: [
        Expanded(
          child: Container(
            color: red,
            child: const Text(
              'This is a very long text that won\'t fit the line.',
              style: big,
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: green,
            child: const Text(
              'Goodbye!',
              style: big,
            ),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example27 extends Example {
  const Example27({Key? key}) : super(key: key);

  @override
  final code = 'Row(children:[\n'
      '   Flexible(\n'
      '       child: Container(color: red, child: Text(\'…\')))\n'
      '   Flexible(\n'
      '       child: Container(color: green, child: Text(\'Goodbye!\'))]';
  @override
  final String explanation =
      'The only difference if you use Flexible instead of Expanded, '
      'is that Flexible lets its child be SMALLER than the Flexible width, '
      'while Expanded forces its child to have the same width of the Expanded.'
      '\n\n'
      'But both Expanded and Flexible ignore their children\'s width when sizing themselves.'
      '\n\n'
      'This means that it\'s IMPOSSIBLE to expand Row children proportionally to their sizes. '
      'The Row either uses the exact child\'s width, or ignores it completely when you use Expanded or Flexible.';

  @override
  Widget build(BuildContext context) {
    // Expanded 대신 Flexible 을 사용하는 경우의 유일한 차이점은
    // Flexible 은 자식이 Flexible 자체와 같거나 [더 작은 너비를 갖도록 하는 반면]
    // Expanded 는 자식이 Expanded 와 정확히 같은 너비를 갖도록 한다는 것입니다.
    // 그러나 Expanded 와 Flexible 은 스스로 크기를 조정할 때 자식의 너비를 무시합니다.
    return Row(
      children: [
        Flexible(
          child: Container(
            color: red,
            child: const Text(
              'This is a very long text that won\'t fit the line.',
              style: big,
            ),
          ),
        ),
        Flexible(
          child: Container(
            color: green,
            child: const Text(
              'Goodbye!',
              style: big,
            ),
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////

class Example28 extends Example {
  const Example28({Key? key}) : super(key: key);

  @override
  final code = 'Scaffold(\n'
      '   body: Container(color: blue,\n'
      '   child: Column(\n'
      '      children: [\n'
      '         Text(\'Hello!\'),\n'
      '         Text(\'Goodbye!\')])))';

  @override
  final String explanation =
      'The screen forces the Scaffold to be exactly the same size as the screen,'
      'so the Scaffold fills the screen.'
      '\n\n'
      'The Scaffold tells the Container that it can be any size it wants, but not bigger than the screen.'
      '\n\n'
      'When a widget tells its child that it can be smaller than a certain size, '
      'we say the widget supplies "loose" constraints to its child. More on that later.';

  @override
  Widget build(BuildContext context) {
    // 화면은 Scaffold 가 화면과 정확히 같은 크기가 되도록 강제하므로
    // Scaffold 가 화면을 채웁니다.
    // Scaffold 는 Container 에게 원하는 크기가 될 수 있지만
    // 화면보다 크지는 않다고 알려줍니다.
    return Scaffold(
      body: Container(
        color: blue,
        child: Column(
          children: const [
            Text('Hello!'),
            Text('Goodbye!'),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////

class Example29 extends Example {
  const Example29({Key? key}) : super(key: key);

  @override
  final code = 'Scaffold(\n'
      '   body: Container(color: blue,\n'
      '   child: SizedBox.expand(\n'
      '      child: Column(\n'
      '         children: [\n'
      '            Text(\'Hello!\'),\n'
      '            Text(\'Goodbye!\')]))))';

  @override
  final String explanation =
      'If you want the Scaffold\'s child to be exactly the same size as the Scaffold itself, '
      'you can wrap its child with SizedBox.expand.'
      '\n\n'
      'When a widget tells its child that it must be of a certain size, '
      'we say the widget supplies "tight" constraints to its child. More on that later.';

  @override
  Widget build(BuildContext context) {
    // Scaffold 의 자식이 Scaffold 자체와 정확히 같은 크기가 되도록 하려면
    // 자식을 SizedBox.expand 로 래핑할 수 있습니다.
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          color: blue,
          child: Column(
            children: const [
              Text('Hello!'),
              Text('Goodbye!'),
            ],
          ),
        ),
      ),
    );
  }
}
