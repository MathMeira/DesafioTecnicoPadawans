import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padawan/models/api.dart';
import 'package:padawan/models/post.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class Posts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PostsState();
  }
}

class PostsState extends State<Posts> {
  var posts = new List<Post>();
  bool sort;
  final _debouncer = Debouncer(milliseconds: 500);

  _getPosts() {
    API.getPosts().then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        posts = lista.map((model) => Post.fromJson(model)).toList();
      });
    });
  }

  PostsState() {
    _getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Postagens'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              hintText: 'Procure por palavra',
            ),
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  posts = posts
                      .where((u) => (u.title
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u.body.toLowerCase().contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
          tabela(),
        ],
      ),
    );
  }

  @override
  void initState() {
    sort = false;
    super.initState();
  }

  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        posts.sort((a, b) => a.id.compareTo(b.id));
      } else {
        posts.sort((a, b) => b.id.compareTo(a.id));
      }
    }
  }

  tabela() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          sortAscending: sort,
          sortColumnIndex: 0,
          columns: <DataColumn>[
            DataColumn(
                label: Text(
                  'ID',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
                numeric: false,
                onSort: (columnIndex, ascending) {
                  setState(() {
                    sort = !sort;
                  });
                  onSortColum(columnIndex, ascending);
                }),
            DataColumn(
              label: Text(
                'Title',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Body',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'User ID',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
          ],
          rows: linha(),
        ),
      ),
    );
  }

  List linha() {
    List linhas = new List<DataRow>();
    for (int i = 0; i < posts.length; i++) {
      linhas.add(DataRow(cells: <DataCell>[
        DataCell(Text(posts[i].id.toString())),
        DataCell(Text(posts[i].title)),
        DataCell(Text(posts[i].body)),
        DataCell(Text(posts[i].userId.toString())),
      ]));
    }
    return linhas;
  }
}
