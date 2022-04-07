import 'package:flutter/material.dart';

import 'object_Terminal.dart';

class noSuchElementException implements Exception {
  String descr;
  noSuchElementException(this.descr);
}

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
    this.ID = this.hashCode;
  }

  bool addTerminal() {
    Terminal newTerminal = Terminal(openTerminals.length, this);
    openTerminals.add(newTerminal);
    return true;
  }

  bool removeTerminal(Terminal toBeRemoved) {
    if (openTerminals.remove(toBeRemoved)) {
      return true;
    } else {
      throw noSuchElementException("Ma questo terminale non esiste");
    }
  }

  String getName() => this.name;
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
    /*Carica gli host dalla memoria*/
    list.add(Host(
        "DummyHost", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
    list.add(Host(
        "DummyHost2", "JustForExample", "127.0.0.1", 22, "giulio", "password"));
  }
}
