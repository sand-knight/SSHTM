import 'package:flutter/material.dart';

AppBar hostsAppBar = AppBar(
  title: const Text("Hosts"),
  leading: Icon(Icons.arrow_left),
  actions: <Widget>[
    Icon(Icons.add),
    Icon(Icons.search),
  ],
  automaticallyImplyLeading: true,
);

Widget hostsBody = Container(
  child: Align(alignment: Alignment.topCenter, child: Text("Hosts?")),
);
