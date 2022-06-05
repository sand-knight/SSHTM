
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/widget_page_form_host.dart';
import 'package:sshtm/Settings/cubit_settings.dart';
import 'package:sshtm/Terminal/widget_page_Terminal.dart';

Future<void> _editHost(BuildContext context, RemoteHost toEdit) async {
  RemoteHost? edited = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context){
        return HostFormPage(toEdit : toEdit);
      }
    )
  );
  if(edited!=null){
    BlocProvider.of<cubit_Hosts>(context).replaceHost(toEdit, edited);
  }
  Navigator.pop(context);
}

class navigation_Sheet extends StatelessWidget {
  final Host selectedHost;
  const navigation_Sheet({Key? key, required this.selectedHost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: BlocProvider.of<cubit_Settings>(context).state.settings.theme,
      child: BlocBuilder<cubit_Hosts, hostsState>(
        builder: (context, state) => DraggableScrollableSheet(
          minChildSize: 0.1,
          maxChildSize: 0.8,
          initialChildSize:
              0.5, //TODO find better formula for dynamic first size
          //min(0.8, 0.11 + 0.05 * selectedHost.openedTerminals().length),
          expand: false,
          builder: (context, controller) => Column(
            children: <Widget>[
              Expanded(

                flex: 0,
                child: ListView(
                  controller: controller,
                  shrinkWrap: true,
                  primary: false,
                  children: [
                    ListTile(
                      tileColor: Theme.of(context).canvasColor,
                      visualDensity: VisualDensity.standard,
                      title: Text(
                        selectedHost.name,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.4,
                        ),
                      leading: (selectedHost is RemoteHost)
                        ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            if (selectedHost is RemoteHost)
                            _editHost(context, selectedHost as RemoteHost);
                          },
                        )
                        : null,
                      trailing: (selectedHost is RemoteHost) 
                        ? IconButton(
                          onPressed: () {
                            BlocProvider.of<cubit_Hosts>(context).removeHost(selectedHost);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete),
                        )
                        : null,
                    ),
                    ListTile(
                      tileColor: Theme.of(context).canvasColor,
                      title: const Text("New Terminal"),
                      leading: const Icon(Icons.add),
                      onTap: () => BlocProvider.of<cubit_Hosts>(context)
                          .addTerminal(selectedHost),
                    )
                  ]
                ),
              ),
              Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: selectedHost.openedTerminals().length,
                    itemBuilder: (context, index) {
                      return ListTile(

                        tileColor: Theme.of(context).primaryColor,
                        dense: true,
                        title: Text(selectedHost
                            .openedTerminals()
                            .elementAt(index)
                            .title),
                        trailing: GestureDetector(
                            child: const Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(Icons.close),
                            ),
                            onTap: () =>
                                BlocProvider.of<cubit_Hosts>(context)
                                    .removeTerminal(
                                        selectedHost
                                            .openedTerminals()
                                            .elementAt(index),
                                        selectedHost)),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return TerminalPage(selectedHost
                                  .openedTerminals()
                                  .elementAt(index));
                              }
                            )
                          );
                        }
                      );
                    }
                ),
              ),
            ]
          )
        )
      )
    );
  }
}
