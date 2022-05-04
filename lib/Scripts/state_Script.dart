
import 'package:sshtm/Scripts/object_Script.dart';

abstract class scriptsState {
  final List<Script> _list;
  List<Script> get list => _list;
  const scriptsState(this._list);
}

class scriptListNotLoadedState extends scriptsState {
  scriptListNotLoadedState(List<Script> list) : super(list);
}

class scriptListLoadedState extends scriptsState {
  scriptListLoadedState(List<Script> list) : super(list);
}