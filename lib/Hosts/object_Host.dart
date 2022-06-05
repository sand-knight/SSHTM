// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:sshtm/Hosts/object_key_chain.dart';
import 'package:sshtm/Hosts/repository_host.dart';
import 'package:sshtm/Terminal/object_terminal_data.dart';

class noSuchElementException implements Exception {
  String descr;
  noSuchElementException(this.descr);
}

abstract class Host {
  final List<TerminalData> _openedTerminals = <TerminalData>[];

  List<TerminalData> openedTerminals() => _openedTerminals;

  bool addTerminal() {
    TerminalData newTerminal = _openedTerminals.isEmpty
        ? TerminalData(0, this)
        : TerminalData(_openedTerminals.last.ID + 1, this);
    _openedTerminals.add(newTerminal);
    return true;
  }

  bool removeTerminal(TerminalData toBeRemoved) {
    if (_openedTerminals.remove(toBeRemoved)) {
      return true;
    } else {
      throw noSuchElementException("Ma questo terminale non esiste");
    }
  }

  void removeTerminalAt(int index) {
    _openedTerminals.removeAt(index);
  }

  String get name => "Android";
}

class AndroidHost extends Host {}

class RemoteHost extends Host {
  //late int _ID;
  final String _name;
  //final String _description;
  final String _address;
  final int _port;
  final String _user;
  KeyChain? _keychain;
  

  RemoteHost._(this._name, this._address, this._port, this._user, this._keychain) {
    /* generate unique id */
    //this._ID = this.hashCode;

  }

  @override
  String get name => _name;
  //String get description => _description;
  String get address => _address;
  int get port => _port;
  String get user => _user;
  KeyChain? get keyChain => _keychain;
  set keyChain(KeyChain? keyChain) {
    _keychain=keyChain?.clone;
  }
 
  

  factory RemoteHost.fromJson(dynamic json) {
    return RemoteHost._(json['name'] as String, json['address'] as String, json['port'] as int, json['user'] as String, null);
  }

  factory RemoteHost({String? name, required String address, required int port,
                      required String userLogin, String? password, String? Pem, String? passPhrase}){
  
  
    if (name == null || name.isEmpty) name=userLogin+"@"+address;

    final newHost=RemoteHost._(name, address, port, userLogin, KeyChain(
        password: password,
        Pem: Pem,
        passphrase: passPhrase,
      ));
    
    return newHost;

  }

  /* JSON decoding / encoding
  */

  Map toJson() => {
    "name" : _name,
    "address" : _address,
    "port" : _port,
    "user" : _user
  };


  @override
  bool operator ==(Object other) => other is RemoteHost 
                                    && _name == other.name
                                    && _address == other.address
                                    && _port == other.port
                                    && _user == user;

  @override
  int get hashCode => hashValues(_name, _address, _port, _user);


}

class HostList {

  HostList (this._repo){
    list.add(AndroidHost());
  }

  
  final List<Host> _list = <Host>[];
  final HostRepository _repo;

  List<Host> get list => _list;

  void removeHost(Host toRemove) {
    if (toRemove is! RemoteHost)
      throw Exception("Delete on Android Host not permitted");
    if (list.remove(toRemove)) {
      _repo.remove(_list.skip(1), toRemove);
    } else {
      throw noSuchElementException("Ma questo host non ci era");
    }
  }

  void add(Host newHost) async {
    list.add(newHost);
    _repo.add(_list.skip(1), newHost);
  }

  void replace(RemoteHost replaced, RemoteHost newer){
    final int i=list.indexOf(replaced);
    _list[i]=newer;

    _repo.replace(replaced, newer, _list.skip(1));
  }

   Future<void> load() async {
    /*
     * Get host list
     */
   
    _list.addAll(await _repo.load());

  }

}
