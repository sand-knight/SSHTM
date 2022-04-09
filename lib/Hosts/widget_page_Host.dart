import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/widget_tile_host.dart';

import 'object_Host.dart';

AppBar hostsAppBar = AppBar(
  title: const Text("Hosts"),
  leading: Icon(Icons.arrow_left),
  actions: <Widget>[
    Icon(Icons.add),
    Icon(Icons.search),
  ],
  automaticallyImplyLeading: true,
);

Widget hostsBody = BlocProvider(
  create: (context) => cubit_Hosts(HostList()),
  child: Align(
      alignment: Alignment.topCenter,
      child: BlocBuilder<cubit_Hosts, hostsState>(builder: (context, state) {
        return ListView(
          children: List.generate(state.getList().length, (index) {
            if (index == 0) {
              //first element is android terminal
              return AndroidTerminaTile(
                  terminalcount: state.getList()[0].openedTerminals().length);
            } else {
              RemoteHost thisTileHost = state.getList()[index] as RemoteHost;
              return HostTile(
                  address: thisTileHost.getAddress(),
                  user: thisTileHost.getUser(),
                  terminalcount: thisTileHost.openedTerminals().length,
                  title: thisTileHost.getName());
            }
          }),
        );
      })),
);
