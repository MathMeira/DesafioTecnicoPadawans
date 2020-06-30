import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padawan/models/api.dart';
import 'package:padawan/models/todo.dart';

class Debouncer{
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action){
    if(null != _timer){
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

}

class Todos extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoState();
  }
}

class TodoState extends State<Todos> {
  var todos = new List<Todo>();
  bool sort;
  final _debouncer =  Debouncer(milliseconds: 500);

  _getTodos() {
    API.getTODOs().then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        todos = lista.map((model) => Todo.fromJson(model)).toList();
      });
    });
  }

  TodoState() {
    _getTodos();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('TODOs'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16.0),
              hintText: 'Procure por palavra',
            ),
            onChanged: (string){
              _debouncer.run((){
                setState(() {
                  todos = todos.where((u) => (u.title.toLowerCase().contains(string.toLowerCase()))).toList();
                });
              });
            },
          ),
          tabela(),
        ],
      )
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
        todos.sort((a, b) => a.id.compareTo(b.id));
      } else {
        todos.sort((a, b) => b.id.compareTo(a.id));
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
                'Feito',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Title',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ),
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

  IconData feito(bool condicao) {
    Icon icone;
    if (condicao) {
      icone = Icon(Icons.check);
    } else {
      icone = Icon(Icons.clear);
    }
    return icone.icon;
  }

  Color cor(bool condicao) {
    if (condicao) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  List linha() {
    List linhas = new List<DataRow>();
    for (int i = 0; i < todos.length; i++) {
      linhas.add(DataRow(cells: <DataCell>[
        DataCell(Icon(
          feito(todos[i].completed),
          color: cor(todos[i].completed),
        )),
        DataCell(Text(todos[i].title)),
        DataCell(Text(todos[i].id.toString())),
        DataCell(Text(todos[i].userId.toString())),
      ]));
    }
    return linhas;
  }
}
