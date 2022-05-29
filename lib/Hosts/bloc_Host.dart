import "package:flutter_bloc/flutter_bloc.dart";
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/repository_host.dart';
import 'package:sshtm/Terminal/object_terminal_data.dart';
import 'package:sshtm/Hosts/state_Host.dart';

class cubit_Hosts extends Cubit<hostsState> {
  HostList _localList; // <-- Istanza  locale della lista
  
  /*
  factory cubit_Hosts(settingsState settings) {
    return cubit_Hosts._(HostList(settings));

  }
  */
  
  cubit_Hosts(HostRepository repository) : _localList=HostList(repository), super(hostsNotLoadedState(const []));

  void addHost(Host newhost) {
    _localList.add(newhost);
    emit(hostAdddedState(_localList.list));
  }

  void removeHost(Host toRemove) {
    _localList.removeHost(toRemove); // TODO Gestire valori di ritorno;
    emit(hostRemovedState(_localList.list));
  }


  void addTerminal(Host host) {
    host.addTerminal();
    emit(hostTerminalAddedState(_localList.list));
  }

  void removeTerminal(TerminalData toBeRemoved, Host host) {
    host.removeTerminal(toBeRemoved); //TODO gestire valori di ritorno
    emit(hostTerminalRemovedState(_localList.list));
  }

  void removeTerminalAt(int index, Host host) {
    host.removeTerminalAt(index); //TODO gestire valori di ritorno
    emit(hostTerminalRemovedState(_localList.list));
  }

  Future<void> loadHosts() async {
    await _localList.load();
    emit(hostsLoadedState(_localList.list));
  }
}
