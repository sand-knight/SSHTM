import 'object_Host.dart';

abstract class hostsState {
  final List<Host> list;
  List<Host> getList() => list;
  const hostsState(this.list);
}

class hostAdddedState extends hostsState {
  /*qui non ci metto la lista per vedere se funziona lo stesso*/
  hostAdddedState(List<Host> list) : super(list);
}

class hostRemovedState extends hostsState {
  hostRemovedState(List<Host> list) : super(list);
}

class hostTerminalAddedState extends hostsState {
  hostTerminalAddedState(List<Host> list) : super(list);
}

class hostTerminalRemovedState extends hostsState {
  hostTerminalRemovedState(List<Host> list) : super(list);
}

class hostsLoadedState extends hostsState {
  hostsLoadedState(List<Host> list) : super(list);
}
