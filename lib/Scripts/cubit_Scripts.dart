import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Scripts/state_Script.dart';

class cubit_Scripts extends Cubit<scriptsState> {
  /* Once again here is the "state", as the changing data structure */
  final ScriptList _localList;

  cubit_Scripts(this._localList) : 
  /* From source: super ( initial state )
    could not, for the life of me, instanciate
    a new ScriptList in the constructor without
    a factory function, if that is a solution
  */
                  super(scriptListNotLoadedState(_localList.list));

  void loadScriptList() {
    _localList.load();
    emit (scriptListLoadedState(_localList.list));
  }

  //TODO void add script from file

  //TODO void add script from text field

  //TODO void remove script


}