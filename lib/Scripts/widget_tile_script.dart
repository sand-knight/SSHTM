
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/object_Job_Controller.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Settings/cubit_settings.dart';

class scriptTile extends StatelessWidget{
  const scriptTile({Key? key, required Script script}) : 
          _myScript=script,
          super (key: key);
          

  final Script _myScript;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      title: Text(_myScript.name) ,
      //isThreeLine:
      onTap: () async {
        List<Host> selectedItems= await showDialog<List<Host>>(
          context: context,
          builder: (context) => BlocBuilder<cubit_Hosts, hostsState>(
            bloc: BlocProvider.of<cubit_Hosts>(context),
            builder: (context, state) {
              ThemeData data= Theme.of(context);
              return MultiSelectDialog<Host>(
                checkColor: data.colorScheme.inversePrimary,
                selectedColor: data.colorScheme.secondary,
                backgroundColor: data.canvasColor ,
                itemsTextStyle: data.textTheme.button,
                selectedItemsTextStyle: data.textTheme.button,
                title: Text("Select Hosts to run ${_myScript.name}"),
                searchable: true,
                initialValue: const [],
                items: List.generate(
                  state.list.length,
                  ((index) => MultiSelectItem(state.list[index], state.list[index].name)),
                )
              );
            },
          ),
        ) ?? [];

        print(selectedItems);

        Job_Controller(
          hosts: selectedItems,
          script: _myScript,
          notifyTo: BlocProvider.of<bloc_Execution>(context),
          settings: BlocProvider.of<cubit_Settings>(context).state.settings,
        ).start();
      
      },

      
      subtitle: Text(
        _myScript.comment,
        maxLines: 2,
      ),    
      
    );
  }
}