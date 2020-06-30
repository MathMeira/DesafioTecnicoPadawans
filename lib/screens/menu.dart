import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padawan/screens/albuns.dart';
import 'package:padawan/screens/posts.dart';
import 'package:padawan/screens/todos.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 16.0),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Text('Postagens', style: TextStyle(fontSize: 16.0),),

              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Posts()));
              },

            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Text('Albuns' , style: TextStyle(fontSize: 16.0),),

              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Albuns()));
              },

            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Text('TODOs' , style: TextStyle(fontSize: 16.0),),

              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Todos()));},

            ),
          ),
        ],
      ),
    );
  }
}
