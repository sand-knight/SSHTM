import 'package:flutter/material.dart';

import 'object_Host.dart';

class Terminal extends StatelessWidget {
  final int _ID;
  final Host _host;
  final String _title;

  Terminal(this._ID, this._host)
      : _title = _host.getName() + " (" + _ID.toString() + ")";

  int getID() => _ID;

  Host getHost() => _host;

  String getTitle() => _title;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Center(
          child: Text("this is the " +
              _ID.toString() +
              "th terminal to " +
              _host.getName()),
        ));
  }
}
