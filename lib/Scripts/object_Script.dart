import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class Script {
  final File _file;
  final String _name;
  late final String comment;

  Script._(this._name, this._file);// : comment= await _retrieveComment();
 /* factory Script(String name, File file) async {
    Script script = Script._(name, file);
    script.comment= await script._retrieveComment();
    return script;
  }
*/

  static Future<Script> fetch(String name, File file) async {
    Script returnee= Script._(name, file);
    returnee.comment= await returnee._retrieveComment();
    return returnee;
  }


  //GET
  String get name => _name;
  String get path => _file.path;
  //Future<String> get comment async{return await _comment;} //dart does not need silly getters

  /*set comment (String newComment){
    comment=newComment;
  }
  */

  set name (String newName){
    String newpath=_file.parent.path+newName;
    try{
      
      _file.rename(newpath);
    } catch (e) {
      print ("Could not rename script. Name was $newpath");
      rethrow;
    }
  }

  Future<String> _retrieveComment() async {
    String temp="";
  
    RandomAccessFile Raf;
    try{
      Raf = await _file.open(mode: FileMode.read);
    }catch (e){
      print("Could not open file content");
      rethrow;
    }
    


    List<int> codelist = <int>[];
    List<int> initialLogo="##SSHTM".codeUnits;
    int char=28;
    int NLcharcode = "\n".codeUnitAt(0) ;
    bool result;

    try{
      int position=await Raf.length();
    
      await Raf.setPosition(position);


      if (position<10) { 
       Raf.close();
      }
    
      do{
        while(position>0 && char!=NLcharcode){ //either a newline or you have parsed the whole doc
          position--;
          await Raf.setPosition(position);

          char = (await Raf.read(1)).elementAt(0); //read one char, which is an Integer
          codelist.add(char);

        }
        char=28;    //random char that does not equal \n, to get into above while
        codelist.removeLast(); //remove last newline

        codelist=codelist.reversed.toList(); //you have read this reversed

    
        if (codelist.length<7) {
          if (codelist.isEmpty) result=true;
          else result=false;
        }                                   //line cannot be less than 7 chars!
        else{

          int i=0;

          while(i<7 && codelist[0]==initialLogo[i]){  //if the first 7 chars are the tag
            codelist.removeAt(0);                     //clean the string
            i++;
          }
          if(i==7) result=true;                        //the string is useful
          else result=false;                           //no, it's junk
        }

      
        if ( result ){
          if (codelist.isNotEmpty) {
            temp=String.fromCharCodes(codelist).trim()+" "+temp;   //save the string
            codelist= <int>[];                 //and empty the char list for next iteration
          }
        
        }
      //} while( result );               //do the above while you're getting comments (multi line?)
      } while( temp.isEmpty );        //do the above untile you have a line

      await Raf.close();
      //comment=temp;
      return temp;

    } catch (e) {
      print ("Exception while trying to read the file content");
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

  Future<void> load() async {
    /* Discovery this' app folder
      Cast is necessary because getExternalStor... is supported onli on Android
      and will generate exception on other platforms
    */

    final Directory appdata = await getExternalStorageDirectory() as Directory;
    _scripdir = Directory.fromRawPath(
        Uint8List.fromList(utf8.encode(appdata.path + "/Scripts")));
    print(_scripdir.path);
    if (!(await _scripdir.exists())) {
      /* folders does not exist: create it and exit, because it's empty*/
      try {
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
        _list.add(await Script.fetch(element.path.split('/').last, element));
      }
    }

  }

  //TODO Add from file
  Future<bool> addScriptFromFile(List<File> toBeAdded) async {
    bool strangeFile = false;
    String shebang = "#!/bin/";
    for (File f in toBeAdded) {
      
      /*try to get a glimpse of the file*/
      try {
        RandomAccessFile content = await f.open( mode : FileMode.read );
        if ( String.fromCharCodes(await content.read(7)).startsWith(shebang) ) {
          strangeFile = true;
        }
        content.close();
      }catch (e){
        print("Could not open file to evaluate");
      } 

      /*try to create new file*/
      String name = f.path.split("/").last;
      String newpath = _scripdir.path + name;
      try {
        File newfile = await f.copy(newpath);
        _list.add(await Script.fetch(name, newfile));
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

      _list.add(await Script.fetch(name, newScript));
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
