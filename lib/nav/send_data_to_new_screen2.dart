import 'package:flutter/material.dart';

import 'send_data_to_new_screen.dart';

// ModalRoute.of() 로 arguments 접근하는 방법
class SendDataToNewScreen2 extends StatelessWidget {
  const SendDataToNewScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Send data to new screen2',
        home: TodosScreen(
            todos: List.generate(
                300,
                (i) => Todo('Todo $i',
                    'A description of what needs to be done for Todo $i'))));
  }
}

class TodosScreen extends StatelessWidget {
  const TodosScreen({Key? key, required this.todos}) : super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: Text(todos[index].title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailScreen(),
                        // arguments 설정
                        settings: RouteSettings(arguments: todos[index])),
                  );
                });
          },
        ));
  }
}

class DetailScreen extends StatelessWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // arguments 접근
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;

    return Scaffold(
        appBar: AppBar(
          title: Text(todo.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(todo.description)));
  }
}
