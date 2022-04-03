import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sshtm/Hosts/object_Host.dart';

abstract class hostrelatedevent {}

class hostrelatedevent_addHost extends hostrelatedevent {}

class hostrelatedevent_removeHost extends hostrelatedevent {}

class hostrelatedevent_addTerminal extends hostrelatedevent {}

class hostrelatedevent_closeTerminal extends hostrelatedevent {}

class blochost extends Bloc<hostrelatedevent, HostList> {
  blochost() : super(HostList()) {
    on<hostrelatedevent_addHost>(((event, emit) => emit(state.add( //e qua che ci metto?

  }
}
