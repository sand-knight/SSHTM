import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Executor/object_Job.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/state_Host.dart';

class scriptTile extends StatelessWidget{
  const scriptTile({Key? key, required Script script}) : 
          _myScript=script,
          super (key: key);
          

  final Script _myScript;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(10),
      title: Text(_myScript.name) ,
      //isThreeLine:
      onTap: () async {
        List<Host> selectedItems= await showDialog<List<Host>>(
          context: context,
          builder: (context) => BlocBuilder<cubit_Hosts, hostsState>(
            bloc: BlocProvider.of<cubit_Hosts>(context),
            builder: (context, state) {
              return MultiSelectDialog<Host>(
                initialValue: const [],
                items: List.generate(
                  state.list.length,
                  ((index) => MultiSelectItem(state.list[index], state.list[index].name)),
                )
              );
            },
          ),
        ) ?? [];

        StreamSink<ExecutionEvent> sink=BlocProvider.of<bloc_Execution>(context).eventStreamSink;

        selectedItems.forEach(
          (element) => sink.add(
            JobEnqueued_ExecutionEvent(
              Job(
                host: element,
                script: _myScript,
                eventStream: sink
              )
            )
          )
        );

      },

      
      subtitle: Text(
        _myScript.comment,
        maxLines: 2,
      ),    
      
    );
  }
}