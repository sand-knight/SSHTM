import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';

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
  child: Center(child: Text("Qui avrà la mia lista!")),
);
