import 'package:flutter/material.dart';

abstract class basetile extends StatelessWidget {
  final String _tilename;
  final int _terminalcount;

  const basetile({Key? key, required String title, required int terminalcount})
      : _tilename = title,
        _terminalcount = terminalcount,
        super(key: key);
}

class AndroidTerminaTile extends basetile {
  const AndroidTerminaTile({Key? key, required int terminalcount})
      : super(
            key: key, title: "Android Terminal", terminalcount: terminalcount);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(_tilename),
          isThreeLine: false,
          trailing: Text(_terminalcount.toString()),
        ));
  }
}

class HostTile extends basetile {
  final String _address;
  final String _user;

  const HostTile(
      {Key? key,
      required String address,
      required String user,
      required int terminalcount,
      required String title})
      : _user = user,
        _address = address,
        super(key: key, title: title, terminalcount: terminalcount);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(this._tilename),
          isThreeLine: true,
          subtitle: Text(this._address + '\n' + this._user),
          trailing: Text(_terminalcount.toString()),
        ));
  }
}
