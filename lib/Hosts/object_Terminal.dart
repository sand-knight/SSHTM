import 'package:flutter/material.dart';

import 'object_Host.dart';

class Terminal extends StatelessWidget {
  int ID;
  Host host;

  Terminal(this.ID, this.host);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(host.name + " (" + ID.toString() + ")"),
      ),
      body: Text("this is a terminal"),
    );
  }
}
