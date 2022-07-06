import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intro_flutter/nav/nav_and_back.dart';
import 'package:intro_flutter/nav/pass_arg_to_named_route.dart';
import 'package:intro_flutter/nav/return_data_from_screen.dart';
import 'package:intro_flutter/nav/send_data_to_new_screen.dart';
import 'package:intro_flutter/ui/assets_and_image.dart';
import 'package:intro_flutter/ui/box_constraints.dart';
import 'package:intro_flutter/ui/interactive_study.dart';
import 'package:intro_flutter/ui/introduction.dart';
import 'package:intro_flutter/ui/layout_study.dart';
import 'package:intro_flutter/ui/layout_tut.dart';
import 'package:intro_flutter/ui/responsive.dart';

import 'advanced_ui/actions_and_shortcuts.dart';
import 'advanced_ui/slivers.dart';
import 'anim/index.dart';
import 'nav/basic.dart';
import 'nav/nav_with_named_routes.dart';
import 'nav/send_data_to_new_screen2.dart';
import 'state_management/basic_state_mng.dart';
import 'state_management/provider.dart';
import 'tutorial/first_infinite_scroll.dart';
import 'ui/state_example.dart';

// [ tutorial ]
// void main() => runApp(const InfiniteList());

// [ ui ]
// void main() => runApp(const Introduction());
// void main() => runApp(const StateExample());
// void main() => runApp(const LayoutStudy());
// void main() => runApp(const LayoutTutorial());
// void main() => runApp(const Responsive());
// void main() => runApp(const InteractiveExample());
// void main() => runApp(const AssetsAndImages());
void main() => runApp(const MyBoxConstraints());

// [ navigation ]
// void main() => runApp(const Basic());
// void main() => runApp(const NavAndBack());
// void main() => runApp(const NavWithNamedRoutes());
// void main() => runApp(const PassArgToNamedRoute());
// void main() => runApp(const ReturnDataFromScreen());
// void main() => runApp(const SendDataToNewScreen());
// void main() => runApp(const SendDataToNewScreen2());
// void main() => runApp(const AnimBasic());
// void main() => runApp(const ActionsAndShortcuts());
// void main() => runApp(const Slivers());
// void main() => runApp(const BasicStateMng());

// void main() => runApp(
//       /// 다양한 상태를 관리하기 위해서는 MultiProvider 를 사용하고
//       /// 사용하려는 상태에 대해서는 ChangeNotifierProvider 를 사용
//       MultiProvider(
//         providers: [
//           ChangeNotifierProvider(create: (_) => Counts()),
//         ],
//         child: const CounterApp(),
//       ),
//     );
