import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/object_Terminal.dart';
import 'package:sshtm/Hosts/state_Host.dart';

class navigation_Sheet extends StatelessWidget {
  final Host selectedHost;
  const navigation_Sheet({Key? key, required this.selectedHost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        minChildSize: 0.1,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, controller) => Column(children: <Widget>[
              ListTile(
                title: Text(selectedHost.getName()),
                leading: const Icon(Icons.edit),
                onTap: () => BlocProvider.of<cubit_Hosts>(context)
                    .addTerminal(selectedHost),
              ),
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
                              .getTitle()),
                          /*trailing: GestureDetector(
                            child: const Icon(Icons.close),
                            onTap: () => BlocProvider.of<cubit_Hosts>(context)
                                .removeTerminal(
                                    selectedHost
                                        .openedTerminals()
                                        .elementAt(index),
                                    selectedHost)),
                                    */
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return selectedHost
                                  .openedTerminals()
                                  .elementAt(index);
                            }));
                          });
                    }),
              ),
              ListTile(
                title: const Text("New Terminal"),
                leading: const Icon(Icons.add),
              )
            ]));
  }
}
