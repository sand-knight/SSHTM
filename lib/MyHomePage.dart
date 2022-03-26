import 'package:flutter/material.dart';

 
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ciao',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Hosts'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.monitor),
              label: "Hosts",
            ),
            BottomNavigationBarItem(
              icon: Icon( Icons.text_snippet ),
              label: "Scripts",
              ),
            BottomNavigationBarItem(
              icon: Icon( Icons.bolt ),
              label: "Actions"
              )
          ]
        ),
      ),
    );
  }
}