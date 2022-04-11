import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/widget_tile_host.dart';

import 'object_Host.dart';

AppBar hostsAppBar = AppBar(
  title: const Text("Host"),
  leading: Icon(Icons.arrow_left),
  actions: <Widget>[
    Icon(Icons.add),
    Icon(Icons.search),
  ],
  automaticallyImplyLeading: true,
);

Widget hostsBody = Center(
  child: BlocProvider(
      create: (context) => cubit_Hosts(HostList()),
      child: BlocBuilder<cubit_Hosts, hostsState>(builder: (context, state) {
        return ListView(
          children: List.generate(state.getList().length, (index) {
            if (index == 0) {
              //first element is android terminal
              return AndroidTerminaTile(
                  host: state.getList()[0] as AndroidHost);
            } else {
              return HostTile(host: state.getList()[index] as RemoteHost);
            }
          }),
        );
      })),
);
