import 'package:flutter/material.dart';

class Todo {
  final String title;
  final String description;

  const Todo(this.title, this.description);
}

// 생성자로 만들기
class SendDataToNewScreen extends StatelessWidget {
  const SendDataToNewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Send data to new screen',
        home: _TodosScreen(
            todos: List.generate(
                200,
                (i) => Todo('Todo $i',
                    'A description of what needs to be done for Todo $i'))));
  }
}

class _TodosScreen extends StatelessWidget {
  const _TodosScreen({Key? key, required this.todos}) : super(key: key);

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
                          builder: (context) =>
                              _DetailScreen(todo: todos[index])));
                });
          },
        ));
  }
}

class _DetailScreen extends StatelessWidget {
  const _DetailScreen({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(todo.title),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(todo.description)));
  }
}
