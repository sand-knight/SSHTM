import 'package:flutter/material.dart';

import 'object_Terminal.dart';

class noSuchElementException implements Exception {
  String descr;
  noSuchElementException(this.descr);
}

abstract class Host {
  List<Terminal> _openedTerminals = <Terminal>[];

  List<Terminal> openedTerminals() => _openedTerminals;

  bool addTerminal() {
    Terminal newTerminal = Terminal(_openedTerminals.length, this);
    _openedTerminals.add(newTerminal);
    return true;
  }

  bool removeTerminal(Terminal toBeRemoved) {
    if (_openedTerminals.remove(toBeRemoved)) {
      return true;
    } else {
      throw noSuchElementException("Ma questo terminale non esiste");
    }
  }

  String getName() => "Android";
}

class AndroidHost extends Host {}

class RemoteHost extends Host {
  late int ID;
  String name;
  String description;
  String address;
  int port;
  String accountName;
  String password;

  RemoteHost(this.name, this.description, this.address, this.port,
      this.accountName, this.password) {
    /* generate unique id */
    this.ID = this.hashCode;
  }

  @override
  String getName() => this.name;

  String getDescription() => description;
  String getAddress() => address;
  int getAssignedPort() => port;
  String getUser() => accountName;
}

class HostList {
  List<Host> list = <Host>[];

  List<Host> get() => list;

  HostList removeHost(Host toRemove) {
    if (list.remove(toRemove)) {
      return this;
    } else {
      throw noSuchElementException("Ma questo host non ci era");
    }
  }

  HostList add(Host newHost) {
    list.add(newHost);
    /*SAVE HOST ON THE DISK*/
    return this;
  }

  HostList() {
    list.add(AndroidHost());
    /*Carica gli host dalla memoria*/
    list.add(RemoteHost(
        "DummyHost", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
    list.add(RemoteHost(
        "DummyHost2", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
  }
}
