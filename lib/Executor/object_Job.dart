// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pty/pty.dart';
import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Executor/state_Execution.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';

class Job {

  final Script _script;
  Future<int>? _exitCode;
  //final StreamSink<ExecutionEvent> _eventStream;
  final bloc_Execution _eventStream;

  Future<int>? get exitCode => _exitCode;

  factory Job({required Host host, required Script script, required bloc_Execution notifyTo}) {
    
    if(host is AndroidHost) return AndroidJob._(script, notifyTo);
    else return RemoteJob._(host, script, notifyTo);

  }

  Job._(this._script, this._eventStream);

  Future<void> start() async{
    throw Exception("You should not be here");
  }

  

}

class AndroidJob extends Job{

  PseudoTerminal? _pty;
//  Future<int>? exitCode;

  AndroidJob._(Script script, bloc_Execution eventStream) : super._(script, eventStream);

  @override
  Future<void> start() async {
    print("Eseguo script");

    _eventStream.add(JobEnqueued_ExecutionEvent(this));

    final Directory appdata = await getExternalStorageDirectory() as Directory;
    String interpreter=await _script.interpreter;
    if (interpreter.isNotEmpty)
    try{
      print("trying to use interpreter from shebang: $interpreter");
      _pty=PseudoTerminal.start(
        interpreter,
        [_script.path],
        workingDirectory: appdata.path,
        environment: Platform.environment,
        blocking: true
      );
    }catch(e){
      try{
        print("Didnt work. trying /bin/sh");
        _pty=PseudoTerminal.start(
        "/bin/sh",
        [_script.path],
        workingDirectory: appdata.path,
        environment: Platform.environment,
        blocking: true
        );
      }catch(i){
        print ("Not even /system/bin/sh");
        rethrow;
      }
    }
    if (_pty==null){
      print ("pty found null. trying /bin/sh");
      _pty=PseudoTerminal.start(
        "/bin/sh",
        [_script.path],
        workingDirectory: appdata.path,
        environment: Platform.environment,
        blocking: true
      );
    }

    String firstLine=_script.name+" on Android: ";
    int secondLineLength=firstLine.length+2;
    String secondLine="";
    
    _pty!.init();

    
    _pty!.out.listen(
      (data) {
        print(data);
        
        if(secondLine.length<secondLineLength){
          secondLine+=data;
        }
      }
    );

    _exitCode=_pty!.exitCode;

    _pty!.exitCode.then(
      (value) {
        firstLine+=exitCode.toString();
        if(secondLine.length>secondLineLength)
          secondLine=secondLine.substring(0,secondLineLength);
        
        _eventStream.add(JobReturned_ExecutionEvent(this, value, firstLine+"\n"+secondLine.replaceAll("\n", " "))); 
      }
    );
    
  }

}

class RemoteJob extends Job{

  final Host _host;

  RemoteJob._(this._host, Script script, bloc_Execution eventStream) : super._(script, eventStream);

}