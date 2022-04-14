import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/widget_navigation_Sheet.dart';
import 'bloc_Host.dart';

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
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          builder: (context) => navigation_Sheet(
              selectedHost:
                  _host)), //BlocProvider.of<cubit_Hosts>(context).addTerminal(_host),
      title: Text(_tilename),
      isThreeLine: false,
      trailing: Text(_host.openedTerminals().length.toString()),
    );
  }
}

class HostTile extends basetile {
  HostTile({Key? key, required RemoteHost host})
      : super(key: key, abhost: host, title: host.getName());

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      onTap: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          builder: (context) => navigation_Sheet(selectedHost: _host)),

      //onTap: () => BlocProvider.of<cubit_Hosts>(context).addTerminal(_host),
      title: Text(_host.getName()),
      isThreeLine: true,
      subtitle: Text((_host as RemoteHost).getAddress() +
          '\n' +
          (_host as RemoteHost).getUser()),
      trailing: Text(_host.openedTerminals().length.toString()),
    );
  }
}
