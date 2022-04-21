
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/widget_page_new_host.dart';
import 'package:sshtm/Hosts/widget_tile_host.dart';

import 'object_Host.dart';

class hostsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const hostsAppBar({Key? key}) : super(key: key);
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: const Text("Host"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context){
                  return NewHostPage();
                }
             )
           );
         }
        ),
      ],
      automaticallyImplyLeading: true,
    );
  }
}

Widget hostsBody = Center(
  child: BlocBuilder<cubit_Hosts, hostsState>(builder: (context, state) {
    return ListView(
      children: List.generate(state.getList().length, (index) {
        if (index == 0) {
          //first element is android terminal
          return AndroidTerminaTile(host: state.getList()[0] as AndroidHost);
        } else {
          return HostTile(host: state.getList()[index] as RemoteHost);
        }
      }),
    );
  }),
);
