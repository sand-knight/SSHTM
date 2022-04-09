import "object_Terminal.dart";

import 'package:flutter/material.dart';

class TerminalPage extends StatelessWidget {
  final Terminal terminal;

  const TerminalPage(this.terminal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Terminal " +
            terminal.getID().toString() +
            " to " +
            terminal.getHost().getName(),
        theme: ThemeData.dark(),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Terminal " +
                  terminal.getID().toString() +
                  " to " +
                  terminal.getHost().getName()),
            ),
            body: Center(
              child: Text("this is a terminal"),
            )));
  }
}
