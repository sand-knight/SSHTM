import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class Script {
  final File _file;
  final String _name;

  Script(this._name, this._file);

  //GET
  String get name => _name;
  String get path => _file.path;

  set name (String newName){
    String newpath=_file.parent.path+name;
    try{
      
      _file.rename(newpath);
    } catch (e) {
      print ("Could not rename script. Name was $newpath");
      rethrow;
    }
  }

  Future<String> get content async {
    try {
      //final File file = File(_pathname);
      Future<String> content = _file.readAsString();
      return content;
    } catch (couldnotreadfile) {
      print ("could not read file");
      rethrow; // TODO i'm expecting this will cause an error mesage and the script will be dropped from the list
    }
  }
}

class ScriptList {
  List<Script> _list = <Script>[];

  List<Script> get list => _list;

  late Directory _scripdir;

  void load() async {
    /* Discovery this' app folder*/
    final Directory appdata = await getApplicationDocumentsDirectory();
    _scripdir = Directory.fromRawPath(
        Uint8List.fromList(utf8.encode(appdata.path + "/Script")));

    if (!(await _scripdir.exists())) {
      /* folders does not exist: create it and exit, because it's empty*/
      try {
        print("Scripdir not found: creating...");
        _scripdir.create();
        return;
      } catch (couldnotcreatefolder) {
        String incriminedPath=_scripdir.path;
        print("Failed to create scripdir of path $incriminedPath");
        rethrow;
      }
    }

    List<FileSystemEntity> directorylist;
    /*the folder exists*/
    try {
      directorylist = _scripdir.listSync();
    } catch (couldnotreadfoldercontent) {
      String incriminedPath=_scripdir.path;
      print("Failed to load directory content at $incriminedPath");
      rethrow;
    }

    for (FileSystemEntity element in directorylist) {
      if (element is File) {
        _list.add(Script(element.path.split('/').last, element));
      }
    }
  }

  //TODO Add from file
  Future<bool> addScriptFromFile(List<File> toBeAdded) async {
    bool strangeFile = false;
    String shebang = "!#/bin/";
    for (File f in toBeAdded) {
      
      /*try to get a glimpse of the file*/
      try {
        if (!(await f.readAsString()).startsWith(shebang)) {
          strangeFile = true;
        }
        
      }catch (e){
        print("Could not open file to evaluate");
      } 

      /*try to create new file*/
      String name = f.path.split("/").last;
      String newpath = _scripdir.path + name;
      try {
        File newfile = await f.copy(newpath);
        _list.add(Script(name, newfile));
      }catch (e) {

        print("Could not open file to evaluate, at $newpath");
        rethrow;
      }
    }

    return strangeFile;
  }

  //TODO Add from text field
  void addScriptFromText(String name, String scriptContent) async {
    String newpath=_scripdir.path + name;
    try {
      File newScript = File(newpath);
      if (await newScript.exists()) {
        throw FileAlreadyExistingException();
      }
      newScript.create();

      newScript.writeAsString(scriptContent);

      _list.add(Script(name, newScript));
    } catch (f) {
      if (f is FileAlreadyExistingException) print("File already exists :(");
      else print("could not create file at $newpath");
      rethrow;
    }
  }

  //TODO remove script
  void deleteScript(Script toDelete) {
    try {
      //File(toDelete._pathname).delete();
      toDelete._file.delete();
      _list.remove(toDelete);
    } catch (e) {
      print("Failed to delete script");
      rethrow;
    }
    
  }
}

class FileAlreadyExistingException extends FileSystemException {}
