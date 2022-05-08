import 'package:flutter/material.dart';
import 'package:sshtm/Scripts/object_Script.dart';

class scriptTile extends StatelessWidget{
  const scriptTile({Key? key, required Script script}) : 
          _myScript=script,
          super (key: key);
          

  final Script _myScript;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(_myScript.name) ,
      //isThreeLine:
      subtitle: Text(
        _myScript.comment,
        maxLines: 2,
      ),    
      
    );
  }
}