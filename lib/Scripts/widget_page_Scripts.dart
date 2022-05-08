// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Scripts/cubit_Scripts.dart';
import 'package:sshtm/Scripts/state_Script.dart';
import 'package:sshtm/Scripts/widget_tile_script.dart';

class scriptsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const scriptsAppBar({Key? key}) : super( key : key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: const Text("Scripts"),
      automaticallyImplyLeading: true,
    );
  }
}

class scriptsBody extends StatelessWidget {
  const scriptsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocProvider(
        create: (context) => cubit_Scripts(),
        child: BlocBuilder<cubit_Scripts, scriptsState>(
          builder: (context, state) {
            if(state is scriptListNotLoadedState) {
              return FutureBuilder<void>(
                future: BlocProvider.of<cubit_Scripts>(context).loadScriptList(),
                builder: (context, AsyncSnapshot<void> snapshot) {
                  if (!snapshot.hasData) 
                    return const Center(
                    child: CircularProgressIndicator(),
                    );
                  else return ListView(
                    children: List.generate(
                      state.list.length,
                      (index) => scriptTile(
                        script: state.list[index]),
                  
                    )
                  );
                },
              );
            }
            return ListView(
              children: List.generate(
                state.list.length,
                  (index) => scriptTile(
                      script: state.list[index]),
                  
              )
            );
          }
        ),
      )
    );
  }
}