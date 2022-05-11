import 'package:pty/pty.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';

class Job {

  final Script _script;

  factory Job({required Host host, required Script script}){
    
    if(host is AndroidHost) return AndroidJob(script);
    else return RemoteJob(host, script);

  }

  Job._(this._script);

}

class AndroidJob extends Job{

  late final PseudoTerminal _pty;
  Future<int>? exitCode;

  AndroidJob(Script script) : super._(script);

  Future<void> start() async {
    print("Eseguo script");
    _pty=PseudoTerminal.start("sh", [_script.path]);

    _pty.out.listen((data) {print(data);});

    exitCode=_pty.exitCode;
  }

}

class RemoteJob extends Job{

  final Host _host;

  RemoteJob(this._host, Script script) : super._(script);

}