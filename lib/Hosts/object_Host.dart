import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sshtm/Hosts/key_chain.dart';
import 'package:sshtm/Settings/cubit_settings.dart';
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
  

  RemoteHost._(this._name, this._address, this._port, this._user) {
    /* generate unique id */
    //this._ID = this.hashCode;

  }

  @override
  String get name => _name;
  //String get description => _description;
  String get address => _address;
  int get port => _port;
  String get user => _user;
  KeyChain? get keyChain {
    final keyVault = Hive.box<KeyChain>("keyVault");
    final KeyChain? answer = keyVault.get(hashCode);
    final String? password = answer?.password;
    print("retrieved $password into $hashCode");
    return answer;
    
  }

  factory RemoteHost.fromJson(dynamic json) {
    return RemoteHost._(json['name'] as String, json['address'] as String, json['port'] as int, json['user'] as String);
  }

  factory RemoteHost({String? name, required String address, required int port,
                      required String userLogin, String? password, String? Pem, String? passPhrase}){
  
  
    if (name == null || name.isEmpty) name=userLogin+"@"+address;

    final newHost=RemoteHost._(name, address, port, userLogin);
    

    final keyVault = Hive.box<KeyChain>("keyVault");
    print("put $password into"+newHost.hashCode.toString());
    keyVault.put(
      newHost.hashCode, KeyChain(
        password: password,
        Pem: Pem,
        passphrase: passPhrase,
      )
    );
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

  HostList (this._settingsCubit){
    list.add(AndroidHost());
  }

  final cubit_Settings _settingsCubit;
  final List<Host> _list = <Host>[];
  late final File _jsonFile;
  List<Host> get list => _list;

  HostList removeHost(Host toRemove) {
    if (list.remove(toRemove)) {
      return this;
    } else {
      throw noSuchElementException("Ma questo host non ci era");
    }
  }

  Future<HostList> add(Host newHost) async {
    list.add(newHost);
    /*SAVE HOST ON THE DISK*/
    await store();
    return this;
  }


  Future<void> store() async {
    List<Host> toBeSaved=_list.skip(1).toList();
    String Json=jsonEncode(toBeSaved);
    _jsonFile.writeAsString(Json);
  }

  Future<void> load() async {
    /*
     * Get host list
     */
    Directory appdata=_settingsCubit.state.settings.appDataFolder;
    _jsonFile = File(appdata.path+"/Hosts.json");
    if (!(await _jsonFile.exists())){
      await _jsonFile.create();
      return;
    }
    String Json=_jsonFile.readAsStringSync();
    if(Json.isEmpty) return;
    final collection=jsonDecode(Json) as List;
    Iterable<Host> readHosts=collection.map((e) => RemoteHost.fromJson(e));
    _list.addAll(readHosts);


  }

}
