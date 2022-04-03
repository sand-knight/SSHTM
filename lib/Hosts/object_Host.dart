import 'package:flutter/material.dart';

import 'object_Terminal.dart';

class Host {
  late int ID;
  String name;
  String description;
  String address;
  int port;
  String accountName;
  String password;
  List<Terminal> openTerminals = <Terminal>[];

  Host(this.name, this.description, this.address, this.port, this.accountName,
      this.password) {
    /* generate unique id */
    ID = this.hashCode;
  }
}

class HostList {
  List<Host> list = <Host>[];

  List<Host> get() => list;

  HostList add(Host newHost) {
    list.add(newHost);
    return this;
    /*SAVE HOST ON THE DISK*/
  }

  HostList() {
    /*Carica gli host dalla memoria*/
    list.add(Host(
        "DummyHost", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
    list.add(Host(
        "DummyHost2", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
  }
}
