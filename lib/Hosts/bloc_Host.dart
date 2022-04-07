import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/object_Terminal.dart';

abstract class hostrelatedevent {}

class hostrelatedevent_removeHost extends hostrelatedevent {}

class hostrelatedevent_addTerminal extends hostrelatedevent {}

class hostrelatedevent_closeTerminal extends hostrelatedevent {}

/* Uso cubit perché non so come passare un operando al bloc */
class cubit_Hosts extends Cubit<HostList> {
  cubit_Hosts() : super(HostList()) {
    /*Hostlist.add ritorna una reference a Hostlist. E' appropriato?*/
    void addHost(Host newhost) {
      emit(state.add(newhost));
    }

    void removeHost(Host toRemove) {
      emit(state.removeHost(toRemove));
    }

    /* Questo funziona? Lo stato è una lista di host, ognuno della quale ha una
        lista di terminali aperti. Agire su un oggetto host ed emettere la lista
        aggiorna lo stato?
    */
    void addTerminal(Host host) {
      host.addTerminal();
      emit(state);
    }

    void removeTerminal(Terminal toBeRemoved, Host host) {
      host.removeTerminal(toBeRemoved);
      emit(state);
    }
  }
}
