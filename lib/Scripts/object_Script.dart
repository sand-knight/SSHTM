import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class Script {

  final String _pathname;
  final String _name;

  Script (this._name, this._pathname);

  Future<String> get content async{
    try {
      final File file = File(_pathname);
      Future<String> content = file.readAsString();
      return content;
    } catch (couldnotreadfile) {
      rethrow; // TODO i'm expecting this will cause an error mesage and the script will be dropped from the list
    }
  }

}

class ScriptList {

  List<Script>_list = <Script>[];

  List<Script> get list => _list;

  void load() async{
    /* Discovery this' app folder*/
    final Directory appdata= await getApplicationDocumentsDirectory();
    final Directory scriptfolder = Directory.fromRawPath( Uint8List.fromList(utf8.encode(appdata.path + "/Script")));
    
    if (!( await scriptfolder.exists() )){
      /* folders does not exist: create it and exit, because it's empty*/
      try {
        scriptfolder.create();
        return;
      } catch (couldnotcreatefolder){
        rethrow;
      }
    }


    List<FileSystemEntity> directorylist;
    /*the folder exists*/
    try{
      directorylist = scriptfolder.listSync();
    } catch (couldnotreadfoldercontent) {
      rethrow;
    }
    
    for (FileSystemEntity element in directorylist) {
        if(element is File){
          _list.add(Script(element.path.split('/').last, element.path));
        }
    }

  }

  //TODO Add from file

  //TODO Add from text field

  //TODO remove script
}