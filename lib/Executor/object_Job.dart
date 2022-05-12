import 'dart:async';

import 'package:pty/pty.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';

class Job {

  final Script _script;
  Future<int>? _exitCode;
  final StreamSink<ExecutionEvent> _eventStream;

  Future<int>? get exitCode => _exitCode;

  factory Job({required Host host, required Script script, required StreamSink<ExecutionEvent> eventStream}) {
    
    if(host is AndroidHost) return AndroidJob._(script, eventStream);
    else return RemoteJob._(host, script, eventStream);

  }

  Job._(this._script, this._eventStream);

  

}

class AndroidJob extends Job{

  late final PseudoTerminal _pty;
//  Future<int>? exitCode;

  AndroidJob._(Script script, StreamSink<ExecutionEvent> eventStream) : super._(script, eventStream);

  Future<void> start() async {
    print("Eseguo script");
    _pty=PseudoTerminal.start("sh", [_script.path]);

    _pty.out.listen((data) {print(data);});

    _exitCode=_pty.exitCode;

    _pty.exitCode.then(
      (value) {_eventStream.add(JobReturned_ExecutionEvent(this, value)); }
      );
    
  }

}

class RemoteJob extends Job{

  final Host _host;

  RemoteJob._(this._host, Script script, StreamSink<ExecutionEvent> eventStream) : super._(script, eventStream);

}