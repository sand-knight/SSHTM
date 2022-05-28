import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Executor/object_Job.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Settings/object_settings_DataStruct.dart';

class Job_Controller {

  final List<Host> _hosts;
  final Script _script;
  final bloc_Execution _bloc;
  final Settings _settings;

  Job_Controller({required List<Host> hosts, required Script script, required bloc_Execution notifyTo, required Settings settings})
    : _hosts=hosts, _script=script, _bloc=notifyTo, _settings=settings;  
  

  void start() async {
    if (_hosts.isEmpty) return;
    String timestamp=DateTime.now().toString();
    
    Directory logFolder=_settings.logFolder;

    if (_hosts.length==1){
      
      /* Only one file, will stay in
       * log folder root
       */


      /* file does not already exist */
      final String filename=logFolder.path
                            +"/"
                            +_script.name
                            +" on "
                            +_hosts[0].name
                            +"_"
                            +timestamp;
      File logfile=File(filename+".txt");
      
      int k=1;
      while(logfile.existsSync()){
        String anotherFilename=filename+"($k)";
        logfile=File(anotherFilename+".txt");
        k++;
      }

      logfile.createSync();

      
      /* 1) create job,
       * 2) send start event
       * 3) wait for exit to send exit event
       */
      final Job toBeExecuted=Job(
        host: _hosts.first,
        script: _script,
        settings: _settings,
        logfile: logfile
      );

      _bloc.add(JobEnqueued_ExecutionEvent(toBeExecuted));

      toBeExecuted.start();
      
      Future.wait([toBeExecuted.shortMessage, toBeExecuted.exitCode,]).then((value) {
        _bloc.add(JobReturned_ExecutionEvent(toBeExecuted, value[1] as int, value[0] as String));
        }
      );
      
    }else
    {
      /* Time stamp is the name of a folder containing all logs
       * from batch.
       * And folder does not already exist.
       */
      final String folderName=logFolder.path+"/"+_script.name+" on selection_"+timestamp;
      logFolder=Directory.fromRawPath(Uint8List.fromList(utf8.encode(folderName)));
    
      int k=1;
      while(logFolder.existsSync()){
        String anotherFolderName=folderName+"($k)";
        logFolder=Directory.fromRawPath(Uint8List.fromList(utf8.encode(anotherFolderName)));
        k++;
      }

      logFolder.createSync();

      Job toBeExecuted;
      File logFile;
      _hosts.forEach((element) {

        final String filename=logFolder.path
                              +"/"
                              +element.name;
                              
        logFile=File(filename+".txt");

        logFile.createSync();


        toBeExecuted=Job(
          host: element,
          script: _script,
          settings: _settings,
          logfile: logFile
        );

        _bloc.add(JobEnqueued_ExecutionEvent(toBeExecuted));

        toBeExecuted.start();
        
        Future.wait([toBeExecuted.shortMessage, toBeExecuted.exitCode,]).then((value) {
          _bloc.add(JobReturned_ExecutionEvent(toBeExecuted, value[1] as int, value[0] as String));
          }
        );

      }
      );
    }
  }

}