import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/Terminal/object_terminal_data.dart';
import 'package:sshtm/Hosts/state_Host.dart';

class cubit_Hosts extends Cubit<hostsState> {
  HostList localList; // <-- Istanza  locale della lista

  //Il costruttore di HostList leggerà dalla memoria la lista, da qui lo stato iniziale?
  cubit_Hosts(this.localList)
      : super(hostsLoadedState(localList.list)); // TODO gestire eccezioni

  void addHost(Host newhost) {
    localList.add(newhost);
    emit(hostAdddedState(localList.list));
  }

  void removeHost(Host toRemove) {
    localList.removeHost(toRemove); // TODO Gestire valori di ritorno;
    emit(hostRemovedState(localList.list));
  }

  /* Questo funziona? Lo stato è una lista di host, ognuno della quale ha una
        lista di terminali aperti. Agire su un oggetto host ed emettere la lista
        aggiorna lo stato?
    */
  void addTerminal(Host host) {
    host.addTerminal();
    emit(hostTerminalAddedState(localList.list));
  }

  void removeTerminal(TerminalData toBeRemoved, Host host) {
    host.removeTerminal(toBeRemoved); //TODO gestire valori di ritorno
    emit(hostTerminalRemovedState(localList.list));
  }

  void removeTerminalAt(int index, Host host) {
    host.removeTerminalAt(index); //TODO gestire valori di ritorno
    emit(hostTerminalRemovedState(localList.list));
  }
}
