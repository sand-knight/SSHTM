
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Settings/cubit_settings.dart';
import 'package:sshtm/Terminal/widget_page_Terminal.dart';

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
                        child: ListTile(
                          title: Text(selectedHost.name),
                          leading: const Icon(Icons.edit),
                        )),
                    Expanded(
                        flex: 0,
                        child: ListTile(
                          title: const Text("New Terminal"),
                          leading: const Icon(Icons.add),
                          onTap: () => BlocProvider.of<cubit_Hosts>(context)
                              .addTerminal(selectedHost),
                        )),
                    Expanded(
                      child: ListView.builder(
                          controller: controller,
                          itemCount: selectedHost.openedTerminals().length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                dense: true,
                                title: Text(selectedHost
                                    .openedTerminals()
                                    .elementAt(index)
                                    .title),
                                trailing: GestureDetector(
                                    child: const Icon(Icons.close),
                                    onTap: () =>
                                        BlocProvider.of<cubit_Hosts>(context)
                                            .removeTerminal(
                                                selectedHost
                                                    .openedTerminals()
                                                    .elementAt(index),
                                                selectedHost)),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return TerminalPage(selectedHost
                                        .openedTerminals()
                                        .elementAt(index));
                                  }));
                                });
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
