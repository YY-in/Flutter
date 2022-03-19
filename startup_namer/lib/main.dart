import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    // return MaterialApp(
    //   title: 'Welcome to Flutter',
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: Text('Welcome to Flutter'),
    //     ),
    //     body: Center(
    //       // child: Text('Hello World'),
    //       // child: Text(wordPair.asPascalCase),
    //       child: RandomWords(),
    //     ),
    //   ),
    // );
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

/*
  添加一个有状态的部件（Stateful widget）
  这至少包含两个类:1. 一个StatefulWidget类，2.一个State类

*/
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  //该方法通过将生成单词对的代码从MyApp移动放到RandomWordsState来生成。
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        //某些wiget属性需要单个widget(child),而其他一些属性，如actiomlist，需要一个widget list用[] 表示
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  //向RandomWordsState中添加一个_suggestions列表，该列表包含每次生成的单词对。该变量以下划线（_）开头，在Dart语言中使用下划线前缀标识符，会强制其变成私有的。
  final _suggestion = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 16.0);

  //添加一个——saved Set(集合)到RandomWordsState中，该集合用于存储用户喜欢的单词对。Set不允许重复值。
  final _saved = Set<WordPair>();

  /*
  向RandomWordsState类中添加一个_buildSuggestions()方法，该方法返回一个ListView。
  ListView类提供一个builder属性，该属性接受一个Widget Function即itemBuilder(BuildContext context, int index)作为参数，返回一个widget。
  */
  Widget _buildSuggestions() {
    // ignore: unnecessary_new
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        //对于每个建议单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          //如果是列表中的最后一个单词对，接着再生成10个单词对，然后添加到建议列表
          if (index >= _suggestion.length) {
            _suggestion.addAll(generateWordPairs().take(10));
          }
          //返回widget，这个widget是一个ListTile组件，用于显示单词对
          return _buildRow(_suggestion[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    //创建一个alreadySaved 来检查确保对保单词对是否已经添加到收藏夹中。
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          //在Flutter的响应框架

          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    //新页面将会在MaterialPageRoute的builder属性中构建，builder是一个匿名函数
    //添加Navigator.push调用，这会使路由入栈
    Navigator.of(context).push(
      new MaterialPageRoute(
        //添加MaterialPageRoute及其builder。现在，添加生成ListTile行的代码。ListTile的divideTiles()方法在每个ListTile之间添加1像素的分割线。
        builder: (context) {
          final tiles = _saved.map(
            (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          //builder返回一个Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        }, 
      )
    );
  }
}
