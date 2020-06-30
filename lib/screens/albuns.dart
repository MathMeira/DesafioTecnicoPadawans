import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padawan/models/api.dart';
import 'package:padawan/models/album.dart';

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

class Albuns extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AlbumState();
  }
}

class AlbumState extends State<Albuns> {
  var albuns = new List<Album>();
  bool sort;
  final _debouncer =  Debouncer(milliseconds: 500);

  _getAlbuns() {
    API.getAlbuns().then((response) {
      setState(() {
        Iterable lista = json.decode(response.body);
        albuns = lista.map((model) => Album.fromJson(model)).toList();
      });
    });
  }

  AlbumState() {
    _getAlbuns();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Albuns'),
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
                  albuns = albuns.where((u) => (u.title.toLowerCase().contains(string.toLowerCase()))).toList();
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
        albuns.sort((a, b) => a.id.compareTo(b.id));
      } else {
        albuns.sort((a, b) => b.id.compareTo(a.id));
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
    for (int i = 0; i < albuns.length; i++) {
      linhas.add(DataRow(cells: <DataCell>[
        DataCell(Text(albuns[i].id.toString())),
        DataCell(Text(albuns[i].title)),
        DataCell(Text(albuns[i].userId.toString())),
      ]));
    }
    return linhas;
  }
}
