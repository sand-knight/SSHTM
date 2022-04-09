import 'package:flutter/material.dart';

import 'object_Host.dart';

class Terminal {
  int ID;
  Host host;

  Terminal(this.ID, this.host);

  int getID() => ID;

  Host getHost() => host;

  /*Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(host.name + " (" + ID.toString() + ")"),
        ),
        body: Center(
          child: Text("this is a terminal"),
        ));
  }
  */
}
