import 'package:sshtm/Hosts/Terminal/object_terminal_data.dart';

class noSuchElementException implements Exception {
  String descr;
  noSuchElementException(this.descr);
}

abstract class Host {
  List<TerminalData> _openedTerminals = <TerminalData>[];

  List<TerminalData> openedTerminals() => _openedTerminals;

  bool addTerminal() {
    TerminalData newTerminal = _openedTerminals.isEmpty
        ? TerminalData(0, this)
        : TerminalData(_openedTerminals.last.ID + 1, this);
    _openedTerminals.add(newTerminal);
    return true;
  }

  bool removeTerminal(TerminalData toBeRemoved) {
    if (_openedTerminals.remove(toBeRemoved)) {
      return true;
    } else {
      throw noSuchElementException("Ma questo terminale non esiste");
    }
  }

  void removeTerminalAt(int index) {
    _openedTerminals.removeAt(index);
  }

  String get name => "Android";
}

class AndroidHost extends Host {}

class RemoteHost extends Host {
  late int _ID;
  final String _name;
  //final String _description;
  String _address;
  int _port;
  String _accountName;
  String _password;

  RemoteHost(this._name, this._address, this._port, this._accountName,
      this._password) {
    /* generate unique id */
    this._ID = this.hashCode;
  }

  @override
  String get name => _name;
  String get password => _password;
  //String get description => _description;
  String get address => _address;
  int get port => _port;
  String get user => _accountName;
}

class HostList {
  List<Host> _list = <Host>[];

  List<Host> get list => _list;

  HostList removeHost(Host toRemove) {
    if (list.remove(toRemove)) {
      return this;
    } else {
      throw noSuchElementException("Ma questo host non ci era");
    }
  }

  HostList add(Host newHost) {
    list.add(newHost);
    /*SAVE HOST ON THE DISK*/
    return this;
  }

  HostList() {
    list.add(AndroidHost());
    /*Carica gli host dalla memoria*/
    list.add(RemoteHost("DummyHost", "127.0.0.1", 22, "giulio", "password"));
    list.add(RemoteHost("DummyHost2", "127.0.0.1", 22, "giulio", "password"));
  }
}
