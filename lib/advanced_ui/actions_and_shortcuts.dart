/*
GUI 애플리케이션이 무엇이든 하려면 액션이 있어야 합니다.
사용자는 애플리케이션에 무언가를 하라고 지시하기를 원합니다.
Actions 는 종종 직접 수행하는 간단한 기능(예: 값 설정 또는 파일 저장)입니다.
(커맨드 패턴의 커맨드같은 클래스)

Actions 를 호출하기 위한 코드와 작업 자체에 대한 코드가 다른 위치에 있어야 할 수도 있습니다.
Shortcuts(키 바인딩)는 호출하는 Actions 에 대해 아무것도 모르는 수준에서 정의가 필요할 수 있습니다.
바로 여기에서 Flutter 의 Actions 및 Shortcuts 시스템이 필요하다.
개발자는 바인딩된 의도를 이행하는 작업을 정의할 수 있습니다.
이 컨텍스트에서 인텐트는 사용자가 수행하려는 일반적인 작업이며
Intent 클래스 인스턴스는 Flutter 에서 이러한 사용자 인텐트를 나타냅니다.
인텐트는 일반 목적일 수 있으며 다양한 컨텍스트에서 다양한 작업을 수행합니다.
Action 은 단순한 콜백(CallbackAction 의 경우처럼)이거나
전체 실행 취소/다시 실행 아키텍처(예:) 또는
기타 논리와 통합되는 더 복잡한 것일 수 있습니다.

Shortcuts 는 키 또는 키 조합을 눌러 활성화되는 키 바인딩입니다.
바로 가기 위젯이 호출하면 일치하는 의도를 실행을 위해 작업 하위 시스템으로 보냅니다.


Intents 에서 Actions 를 분리하는 이유는? 키 조합을 Actions 에 직접 매핑하지 않는 이유는?
Intents 가 전혀 없는 이유는 무엇입니까?
이는 키 매핑 정의가 있는 위치(종종 높은 수준)와 작업 정의가 있는 위치(종종 낮은 수준)
사이에 문제를 분리하는 것이 유용하기 때문입니다.

예를 들어 DirectionalFocusIntent 는 포커스를 이동할 방향을 가져와서
DirectionalFocusAction 이 포커스를 이동할 방향을 알 수 있도록 합니다.
주의: 모든 Action 호출에 적용되는 Intent 의 상태를 전달하지 마십시오.
Intent 가 너무 많이 알 필요가 없도록 하려면 그러한 종류의 상태를
Action 자체의 생성자에 전달해야 합니다.

요약하자면 SOLID 한 구현을 위한 아키텍처 틀을 제공한다.
단축키와 BM을 분리하도록 빌트인 클래스를 제공하는  것

콜백을 사용하지 않는 이유는 무엇입니까?
또한 Action 객체 대신 콜백을 사용하지 않는 이유가 궁금할 수도 있습니다.
주된 이유는 액션이 isEnabled 를 구현하여 활성화 여부를 결정하는 것이 유용하기 때문
또한 키 바인딩과 이러한 바인딩의 구현이 서로 다른 위치에 있으면 종종 도움이 됩니다.
실제로 필요한 모든 것이 콜백이면 Actions 및 Shortcuts 의 복잡성(또는 유연성) 없이
바로 사용할 수 있습니다. 이를 위한 포커스 위젯이 있다.

Shortcuts:
액션을 키보드 단축키에 바인딩하는 것
Shortcuts 는 위젯 계층에 삽입되어 해당 키 조합을 눌렀을 때 사용자의 의도를 나타내는
키 조합을 정의합니다. 키 조합의 의도된 목적을 구체적인 작업으로 변환하기 위해
Actions 위젯은 의도를 Actions 에 매핑하는 데 사용됩니다.
예를 들어, SelectAllIntent 를 정의하고 이를 자신의 SelectAllAction
또는 CanvasSelectAllAction 에 바인딩할 수 있으며,
하나의 키 바인딩에서 시스템은 애플리케이션의 어느 부분에 포커스가 있는지에 따라
둘 중 하나를 호출합니다.

Action Dispatchers:
대부분의 경우 작업을 호출하고 해당 작업을 수행하고 잊어버리기를 원합니다.
그러나 때로는 실행된 작업을 기록하고 싶을 수도 있습니다.
여기에서 기본 ActionDispatcher 를 사용자 지정 디스패처로 교체하는 것이 필요합니다.
ActionDispatcher 를 Actions 위젯에 전달하면
액션을 호출할 때 Actions 가 수행하는 첫 번째 작업은
ActionDispatcher 를 조회하고 호출을 위해 액션을 전달하는 것입니다.
아무것도 없으면 단순히 작업을 호출하는 기본 ActionDispatcher 를 만듭니다.

ShortcutManager:
Shortcuts 위젯보다 수명이 긴 객체인 ShortcutManager 는 키 이벤트를
수신할 때 키 이벤트를 전달한다. 여기에는 키를 처리하는 방법을 결정하기 위한 로직,
다른 바로가기 매핑을 찾기 위해 트리 위로 올라가는 로직이 포함되어 있으며,
키 조합의 의도에 대한 맵을 유지관리 한다.
ShortcutManager 의 기본 동작이 일반적으로 바람직하지만
Shortcuts 위젯은 기능을 사용자 정의하기 위해 하위 클래스로 만들 수 있는
ShortcutManager 를 사용한다.
예를 들면 ShortcutManager 위젯이 처리한 각 키를 기록하려면
LoggingShortcutManager 를 만들 수 있다.

Actions:
Actions 를 통해 애플리케이션이 Intent 로 수행할 수 있는 작업을 정의할 수 있음
작업을 활성화하거나 비활성화할 수 있으며,
intent 에 의해 허용하는 인수로 작업을 호출한 의도 인스턴스를 수신합니다.

action 은 Action<T> 를 상속받아 invoke 를 override 하면 된다.
클래스를 구현하기 귀찮다면 CallbackAction(onInvoke: (Intent intent) => model.selectAll())
처럼 CallbackAction 를 사용하라.

Shortcuts 위젯은 Focus 위젯의 컨텍스트와 Actions.invoke 를 사용하여
호출할 작업을 찾습니다.
Shortcuts 위젯이 발견된 첫 번째 Actions 위젯에서 일치하는 intent 유형을
찾지 못하면 위젯 트리의 루트에 도달하거나 일치하는 의도 유형을 찾아서
호출할 때까지 다음 상위 작업 위젯 등을 고려합니다. 해당 조치.

Action 을 intent 와 함께 정의하고
이 액션을 Shortcuts 에 바인딩하여 단축키에서도 쓰고,
버튼이나 실 UI 에도 바인딩 시켜서 press 할 때
해당 인텐트를 실행할 수 있다.

Actions 위젯은 isEnabled 가 참인 경우 액션을 실행한다.

[ 단축키 위젯 만드는 절차 ]
1. 인텐트와 액션 정의
2. Shortcuts 에 manager, shortcuts, child 정의
  manager: 단축키 누를때마다 실행할 클래스,
  shortcuts: 단축키와 인텐트 맵
  child: Actions 를 포함한 위젯
3. Actions 에 dispatcher, actions, child 정의
  dispatcher 는 매 액션 수행시 실행할 클래스
  actions 는 인텐트와 실행할 클래스 맵
  child 는 실제 렌더링할 위젯
단축키와 기능은 Shortcuts 에서 징의 및 연결이 되었고
버튼이나 위젯에 달 기능들은 Actions 의 child 이하에서 인텐트를 실행하면 됨
manager 와 dispatcher 는 재정의 하지 않으면 기본 값이 사용됨(옵셔널이다)
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActionsAndShortcuts extends StatelessWidget {
  const ActionsAndShortcuts({Key? key}) : super(key: key);

  static const String title = 'Shortcuts and Actions Demo';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      /// 2. 단축키가 필요한 렌더 트리에 단축키 등록
      home: Shortcuts(
        // 키 입력마다 이벤트가 필요하면 ShortcutManager 상속 구현
        // todo 이거 원래 되던 코든데 언젠가부터 안되서 일단 주석처리
        // manager: LoggingShortcutManager(),
        // {키: 인텐트}로 키와 실행할 것(인텐트) 매핑
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.escape): const ClearIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyC):
          const CopyIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
          const SelectAllIntent(),
        },
        /// 3. 원래 렌더링 했어야 할 위젯 정의
        child: const CopyableTextField(title: title),
      )
    );
  }
}

class CopyableTextField extends StatefulWidget {
  const CopyableTextField({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CopyableTextFieldState createState() => _CopyableTextFieldState();
}

class _CopyableTextFieldState extends State<CopyableTextField> {
  late TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 4. Actions 정의
    return Actions(
        dispatcher: LoggingActionDispatcher(),
        actions: <Type, Action<Intent>>{
          ClearIntent: ClearAction(controller),
          CopyIntent: CopyAction(controller),
          SelectAllIntent: SelectAllAction(controller),
        },
        /// 5. 위젯 정의
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Shortcuts and Actions'),
            ),
            body: Center(
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  Expanded(
                    child: TextField(controller: controller),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: Actions.handler<CopyIntent>(
                        context, const CopyIntent()),
                  ),
                  IconButton(
                    icon: const Icon(Icons.select_all),
                    onPressed: Actions.handler<SelectAllIntent>(
                        context, const SelectAllIntent()),
                  ),
                  const Spacer()
                ],
              ),
            ),
          );
        }));
  }
}

/// 처리하는 모든 키를 기록하는 ShortcutManager
class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, RawKeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      print('Handled shortcut $event in $context');
    }
    return result;
  }
}

/// 호출하는 모든 작업을 기록하는 ActionDispatcher
class LoggingActionDispatcher extends ActionDispatcher {
  @override
  Object? invokeAction(
    covariant Action<Intent> action,
    covariant Intent intent, [
    BuildContext? context,
  ]) {
    print('Action invoked: $action($intent) from $context');
    super.invokeAction(action, intent, context);
  }
}

/// 1. 각 인텐트와 액션 정의
/// 지우기 위해 ClearAction 에 바인딩된 인텐트
class ClearIntent extends Intent {
  const ClearIntent();
}
/// ClearIntent 에 바인딩되어 해당 작업을 지우는 작업
class ClearAction extends Action<ClearIntent> {
  ClearAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant ClearIntent intent) {
    controller.clear();
  }
}

/// TextEditingController 에서 복사하기 위해 CopyAction 에 바인딩된 인텐트
class CopyIntent extends Intent {
  const CopyIntent();
}
class CopyAction extends Action<CopyIntent> {
  CopyAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant CopyIntent intent) {
    final String selectedString = controller.text.substring(
        controller.selection.baseOffset, controller.selection.extentOffset);
    Clipboard.setData(ClipboardData(text: selectedString));
  }
}

// 문자열을 전체 선택하기 위한 인텐트
class SelectAllIntent extends Intent {
  const SelectAllIntent();
}
class SelectAllAction extends Action<SelectAllIntent> {
  SelectAllAction(this.controller);

  final TextEditingController controller;

  @override
  Object? invoke(covariant SelectAllIntent intent) {
    controller.selection = controller.selection.copyWith(
      baseOffset: 0,
      extentOffset: controller.text.length,
      affinity: controller.selection.affinity,
    );
  }
}

/// 액티베이터의 맵을 취하고 이에 대한 콜백을 실행하는 간단한 위젯
/// 단일 키에 대한 단순한 키매핑
class CallBackShortcuts extends StatelessWidget {
  const CallBackShortcuts(
      {Key? key, required this.bindings, required this.child})
      : super(key: key);

  final Map<ShortcutActivator, VoidCallback> bindings;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (FocusNode node, RawKeyEvent evt) {
        KeyEventResult result = KeyEventResult.ignored;

        for (final ShortcutActivator activator in bindings.keys) {
          if (activator.accepts(evt, RawKeyboard.instance)) {
            bindings[activator]!.call();
            result = KeyEventResult.handled;
          }
        }
        return result;
      },
      child: child,
    );
  }
}
