
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/widget_page_new_host.dart';
import 'package:sshtm/Hosts/widget_tile_host.dart';

import 'package:sshtm/Hosts/object_Host.dart';

class hostsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const hostsAppBar({Key? key}) : super(key: key);
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: const Text("Hosts"),
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

class hostsBody extends StatelessWidget {
  const hostsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: BlocBuilder<cubit_Hosts, hostsState>(
        builder: (context, state) {
          if(state is hostsNotLoadedState){
            BlocProvider.of<cubit_Hosts>(context).loadHosts();
            return const Center(
                    child: CircularProgressIndicator(),
            );

          }else return ListView(
            children: List.generate(
              state.list.length,
              (index) {
                if (index == 0) {
                  //first element is android terminal
                  return AndroidTerminaTile(host: state.list[0] as AndroidHost);
                } else {
                  return HostTile(host: state.list[index] as RemoteHost);
                }
              }
            ),
          );
        }
      )
    );
  }
}
