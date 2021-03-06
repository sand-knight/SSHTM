import 'package:flutter/material.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/widget_navigation_Sheet.dart';

abstract class basetile extends StatelessWidget {
  final String _tilename;
  final Host _host;

  const basetile({Key? key, required String title, required Host abhost})
      : _tilename = title,
        _host = abhost,
        super(key: key);
}

class AndroidTerminaTile extends basetile {
  const AndroidTerminaTile({Key? key, required AndroidHost host})
      : super(key: key, title: "Android Terminal", abhost: host);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: () => showModalBottomSheet(
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => navigation_Sheet(
          selectedHost: _host
          )
      ),
      title: Text(_tilename),
      isThreeLine: false,
      trailing: Text(_host.openedTerminals().length.toString()),
    );
  }
}

class HostTile extends basetile {
  HostTile({Key? key, required RemoteHost host})
      : super(key: key, abhost: host, title: host.name);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: () => showModalBottomSheet<void>(
        backgroundColor: Theme.of(context).primaryColor,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) => navigation_Sheet(selectedHost: _host)),

      //onTap: () => BlocProvider.of<cubit_Hosts>(context).addTerminal(_host),
      title: Text(_host.name),
      isThreeLine: true,
      subtitle: Text(
          (_host as RemoteHost).address + '\n' + (_host as RemoteHost).user),
      trailing: Text(_host.openedTerminals().length.toString()),
    );
  }
}
