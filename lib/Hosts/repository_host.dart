// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:sshtm/Hosts/key_chain.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Settings/cubit_settings.dart';

class HostRepository{

  HostRepository(this._cubit);

  File? _jsonFile;
  final cubit_Settings _cubit;

  Future<void> init() async{
    if (_cubit.state.settings.storageChoices["hostsInStorage"]!){
      Directory appdata=_cubit.state.settings.appDataFolder;
      _jsonFile = File(appdata.path+"/Hosts.json");
      
      if (!(await _jsonFile!.exists())){
        await _jsonFile!.create();
      }
    }
    if (_cubit.state.settings.storageChoices["hostsInFirebase"]!){
      /*
       * This is not even a promise :P
       */
    }

  }

  Future<Iterable<RemoteHost>> load() async{
    List<RemoteHost>? readHosts;
    if (_cubit.state.settings.storageChoices["hostsInStorage"]!){
      if (_jsonFile == null) await init();
      String Json=_jsonFile!.readAsStringSync();
      if (Json.isNotEmpty) {
        final collection=jsonDecode(Json) as List;
        readHosts=collection.map((e) => RemoteHost.fromJson(e)).toList();
      }
      else readHosts=[];
      
    }
    if (_cubit.state.settings.storageChoices["hostsInFirebase"]!){
      /* this is not even a promise :P */
      readHosts= [];
    }

    if (readHosts==null) throw Exception("Inconsistent state");

    if (_cubit.state.settings.storageChoices["passwordsInHive"]!){
      final keyVault = Hive.box<KeyChain>("keyVault");
      KeyChain? answer;
      for (RemoteHost element in readHosts){
          answer = keyVault.get(element.hashCode);
          
          element.keyChain=answer;
      }

    }

    return readHosts;
  }

  Future<void> add(Iterable<Host> snapshot, Host newHost) async {
    if (newHost is! RemoteHost) throw Exception("$newHost is not remotehost");
    if (_cubit.state.settings.storageChoices["hostsInStorage"]!){
      if (_jsonFile == null) await init();
      await _storeJson(snapshot);
    }
    if (_cubit.state.settings.storageChoices["hostsInFirebase"]!){
      /*
       * Not even a promise :P
       */
    }
    if (_cubit.state.settings.storageChoices["passwordsInHive"]!){
      final keyVault = Hive.box<KeyChain>("keyVault");
      print("put ${newHost.keyChain} into"+newHost.hashCode.toString());
      await keyVault.put(newHost, newHost.keyChain!);
    }
     
  }

  Future<void> remove(Iterable<Host> snapshot, Host toBeRemoved) async {
    if (toBeRemoved is! RemoteHost) throw Exception("$toBeRemoved is not remotehost");
    if (_cubit.state.settings.storageChoices["hostsInStorage"]!){
      if (_jsonFile == null) await init();
      await _storeJson(snapshot);
    }
    if (_cubit.state.settings.storageChoices["hostsInFirebase"]!){
      /*
       * Not even a promise :P
       */
    }
    if (_cubit.state.settings.storageChoices["passwordsInHive"]!){
      final keyVault = Hive.box<KeyChain>("keyVault");
      print("removed ${toBeRemoved.keyChain} into"+toBeRemoved.hashCode.toString());
      await keyVault.delete(toBeRemoved);
    }
    throw Exception("Inconsistent state");
  }

  Future<void> _storeJson (Iterable<Host> snapshot) async{
    String Json=jsonEncode(snapshot.toList());
    _jsonFile!.writeAsString(Json);
  }
}