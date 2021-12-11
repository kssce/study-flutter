import 'package:flutter/material.dart';

class LayoutTutorial extends StatelessWidget {
  const LayoutTutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'layout tutorial',
        home: Scaffold(
            appBar: AppBar(title: const Text('Flutter layout demo')),
            body: ListView(children: [
              _imageCover(),
              _titleSection(),
              _buttons(context),
              _description(),
            ])));
  }
}

Widget _imageCover() {
  return Image.asset('assets/images/cat2.png', width: 600, height: 240, fit: BoxFit.cover);
}

Widget _titleSection() {
  return Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  '안녕하신가 힘세고 강한 아침',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '만일 내게 물어보면, 나는 왈도',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        ),
        Icon(
          Icons.star,
          color: Colors.red[500],
        ),
        const Text('41'),
      ],
    ),
  );
}

Widget _buttons(BuildContext context) {
  var clr = Theme.of(context).primaryColor;
  return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
    _button(clr, Icons.call, 'CALL'),
    _button(clr, Icons.near_me, 'ROUTE'),
    _button(clr, Icons.share, 'SHARE'),
  ]);
}

Widget _button(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(icon, color: color),
      Container(
        margin: const EdgeInsets.only(top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

Widget _description() {
  return Container(
      padding: const EdgeInsets.all(32),
      child: const Text(
        '안녕하신가, 힘세고 강한 아침. 만일 내게 물어보면 나는 왈도. '
        'Alps. Situated 1,578 meters above sea level, it is one of the '
        'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        'half-hour walk through pastures and pine forest, leads you to the '
        'lake, which warms to 20 degrees Celsius in the summer. Activities ',
        softWrap: true,
      ));
}
