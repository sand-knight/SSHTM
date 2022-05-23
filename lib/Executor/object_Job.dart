// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:dartssh2/dartssh2.dart';
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
	 else return RemoteJob._(host as RemoteHost, script, notifyTo);

	}

	Job._(this._script, this._eventStream);

	Future<void> start() async{
	 throw Exception("You should not be here");
	}

	

}

/* 
ALT2 is an alternative mode in which we instantiate a normal login shell
	and then we call the interpreter on the script. However in that mode
	output is inconsistent for some reason. To try remove ALT1 lines and
	uncomment ALT2 lines.
*/
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

	 if (interpreter.isEmpty) throw InterpreterNotUnderstood("interpreter string found empty");
	 
	 List<String> arguments=interpreter.split(' ');
	 interpreter=arguments.first; // ALT1
	 arguments.removeAt(0);
	 arguments.add(_script.path);
	 
	 final File interpreterFile=File(interpreter);
	 if (!interpreterFile.existsSync()) throw InterpreterNotUnderstood("interpreter not found in file system");
	 
	 
	 // ALT2 String executeNreturn=interpreter+" "+_script.path+"; exit \$?\n";

	 try{
		print("trying to use interpreter from shebang: $interpreter");
		_pty=PseudoTerminal.start(
			interpreter,
			// ALT2 "/bin/sh",
			arguments,
			// ALT2 [],
			workingDirectory: appdata.path,
			environment: Platform.environment,
			blocking: true
		);
		}catch(e){
		
			print("Didnt work.");
			rethrow;
		
		}
		if (_pty==null){
			print ("pty found null. trying /bin/sh");
			throw ExecutorException("pty found null");
		}

	 String firstLine=_script.name+" on Android: ";
	 // ALT2 int junkLength=executeNreturn.length*2+appdata.path.length+5;
	 int secondLineLength=firstLine.length; // ALT2 +junkLength;
	 String secondLine="";
	 
	 _pty!.init();

	 // ALT2 _pty!.write(executeNreturn);
	 
	 
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
			firstLine+=value.toString();

			if(secondLine.length>secondLineLength)
				secondLine=secondLine.substring(0, secondLineLength); // ALT1
			// ALT2 secondLine=secondLine.substring(junkLenght,secondLineLength);
			// ALT2 else secondLine=secondLine.substring(junkLenght);
			
			_eventStream.add(JobReturned_ExecutionEvent(this, value, firstLine+"\n"+secondLine.replaceAll("\n", " ")+"…")); 
		}
	 );
	 
	}

}

class RemoteJob extends Job{

	final RemoteHost _host;

	RemoteJob._(this._host, Script script, bloc_Execution eventStream) : super._(script, eventStream);
 
	@override
	Future<void> start() async{

		_eventStream.add(JobEnqueued_ExecutionEvent(this));

		final socket = await SSHSocket.connect(_host.address, _host.port );


		final client;
		try{
			client = SSHClient(
				socket,
				username: _host.user ,
				onPasswordRequest: () => _host.password,
				
			);
		}catch(e){
			final String message=e.toString();
			_eventStream.add(JobReturned_ExecutionEvent(this, -1, "failed to execute\n"+message));
			return;
		}
	
		/*
		 *	1) Create a temp file
		 * 2) put script content
		 * 
		 */
		final String tempath= utf8.decode( await client.run('mktemp') ).replaceAll('\n', "");
		final sftp = await client.sftp();
		print("Hopefully created temp file in $tempath");
		final remotescript = await sftp.open(
			tempath,
			mode: SftpFileOpenMode.truncate | SftpFileOpenMode.write
			);

		await remotescript.write(_script.file.openRead().cast());
		await remotescript.close();
		sftp.close();


		/*
		 * Utility on strings
		 */
		String firstLine = _script.name+" on "+_host.name+": ";
		final int secondLineLength=firstLine.length;


		/*
		 * 1) execute script
		 * 2) get exit code
		 */
		
		final String command=(await _script.interpreter)+" "+tempath;
		final SSHSession executor= await client.execute(command);
		
		String data, secondLine="";

		Stream<Uint8List> output = StreamGroup.merge([executor.stdout, executor.stderr]);
		output.forEach(
			(element) {
				
				data=utf8.decode(element);
				if (secondLine.length<secondLineLength){
					secondLine+=data;
				}

				print("$data");

				// TODO data --> logs

			}
		);
		
		await executor.done;
		final int exitCode=executor.exitCode!;
		executor.close();
		
		
		await client.run("rm $tempath");
		client.close();

		
		await client.done;
		await socket.close();

		if (secondLine.length>secondLineLength){
					secondLine=secondLine.substring(0,secondLineLength);
				}
		firstLine+=exitCode.toString();
		_eventStream.add(JobReturned_ExecutionEvent(this, exitCode, firstLine+"\n"+secondLine.replaceAll("\n", " ")+"…"));
		
	}
}


class ExecutorException implements Exception {
	final String msg;
	const ExecutorException(this.msg);
	String toString() => 'Executor Exception: $msg';
}

class InterpreterNotUnderstood extends ExecutorException{
	InterpreterNotUnderstood(String msg) : super(msg);
}