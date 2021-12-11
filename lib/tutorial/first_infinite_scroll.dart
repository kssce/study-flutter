import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

/// Lazy 한 무한 스크롤
class InfiniteList extends StatelessWidget {
  const InfiniteList({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Flutter 에서는 정렬, 여백, 레이아웃 등 거의 모든것이 위젯
    // 머티리얼 라이브러리의 Scaffold 위젯은 홈 스크린의 위젯 트리를 구성하는 app bar, title, body 속성을 기본으로 제공
    return const MaterialApp(
        title: 'Startup Name Generator', home: _RandomWords());
  }
}

// 상태 클래스
class _RandomWords extends StatefulWidget {
  const _RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<_RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Startup name Generator')),
        body: _buildSuggestions());
  }
}
