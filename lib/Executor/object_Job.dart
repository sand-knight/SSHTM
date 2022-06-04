// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:async/async.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:pty/pty.dart';
import 'package:sshtm/Hosts/object_key_chain.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Settings/object_settings_DataStruct.dart';

class Job {

  final File _logfile;
  final Script _script;
	late final Future<int> _exitCode;
  late final Future<String> _shortMessage;
  final _exitCodeCompleter = Completer<int>();
  final _shortMessageCompleter = Completer<String>();
  //Completer
	
	Future<int> get exitCode => _exitCode;
  Future<String> get shortMessage => _shortMessage;

	factory Job({required Host host, required Script script, required File logfile, required Settings settings}) {
	 
	 if(host is AndroidHost) return AndroidJob._(script, logfile, settings);
	 else return RemoteJob._(host as RemoteHost, script, logfile);

	}

	Job._(this._script, this._logfile){
    _shortMessage=_shortMessageCompleter.future;
    _exitCode=_exitCodeCompleter.future;
  }

	Future<void> start() async{
	 throw Exception("You should not be here");
	}

	

}

/* 
ALT2 is an alternative mode in which we instantiate a normal login shell
	and then we call the interpreter on the script. However in that mode
	output is inconsistent for some reason. To try, remove ALT1 lines and
	uncomment ALT2 lines.
*/
class AndroidJob extends Job{
  final Settings _settings;
	PseudoTerminal? _pty;
//  Future<int>? exitCode;

	AndroidJob._(Script script, File logFile, Settings settings)
   : _settings=settings, super._(script, logFile);

	@override
	Future<void> start() async {
	  print("Eseguo script");

	  //---------------------------------------------  PTY PARAMETERS CONTROL
	  String interpreter=await _script.interpreter;

	  if (interpreter.isEmpty) throw InterpreterNotUnderstood("interpreter string found empty");
	 
    List<String> arguments=interpreter.split(' ');
    interpreter=arguments.first; // ALT1
    arguments.removeAt(0);
    arguments.add(_script.path);
    
    final File interpreterFile=File(interpreter);
    if (!interpreterFile.existsSync()) throw InterpreterNotUnderstood("interpreter not found in file system");
    
    final String tempstring=_settings.appDataFolder.path;
    // ALT2 String executeNreturn=interpreter+" "+_script.path+"; exit \$?\n";
    print ( "try $interpreter on $arguments in $tempstring");
	  try{
      print("trying to use interpreter from shebang: $interpreter");
      _pty=PseudoTerminal.start(
        interpreter,
        // ALT2 "/bin/sh",
        arguments,
        // ALT2 [],
        workingDirectory: _settings.appDataFolder.path,
        environment: Platform.environment,
        blocking: true
      );
		}catch(e){
		
			final String message=e.toString();
			_exitCodeCompleter.complete(-1);
      _shortMessageCompleter.complete(message);
			return;
		
		}
		if (_pty==null){
			_exitCodeCompleter.complete(-1);
      _shortMessageCompleter.complete("Pty Exception: pty found null");
			return;
		}

    /* init output variables  */ //-------------------- OUTPUT
	 String firstLine=_script.name+" on Android: ";
	 // ALT2 int junkLength=executeNreturn.length*2+appdata.path.length+5;
	 int secondLineLength=firstLine.length; // ALT2 +junkLength;
	 String secondLine="";

    final IOSink outputlog=_logfile.openWrite(mode: FileMode.append);


	 
	 _pty!.init(); // <---------------------------------- INIT

	 // ALT2 _pty!.write(executeNreturn);
	 
	 
	 _pty!.out.listen( //<------------------------------ output subscription
		(data) {
			print(data);
			
      outputlog.add(utf8.encode(data));

			if(secondLine.length<secondLineLength){
			 secondLine+=data;
			}
		}
	 );

	 _exitCodeCompleter.complete(_pty!.exitCode);
   

	 _exitCode.then(
		(value) {
			firstLine+=value.toString();

			if(secondLine.length>secondLineLength)
				secondLine=secondLine.substring(0, secondLineLength); // ALT1
			// ALT2 secondLine=secondLine.substring(junkLenght,secondLineLength);
			// ALT2 else secondLine=secondLine.substring(junkLenght);

			_shortMessageCompleter.complete(firstLine+"\n"+secondLine.replaceAll("\n", " ")+"…");
			
		}
	 );
	 
	}

}

class RemoteJob extends Job{

	final RemoteHost _host;

	RemoteJob._(this._host, Script script, File logfile) : super._(script, logfile);
 
	@override
	Future<void> start() async{


    //------------------------------------------  SSH INITIALIZATION

		final SSHSocket socket = await SSHSocket.connect(_host.address, _host.port );

    List<SSHKeyPair>? keyPairs;
    final KeyChain keyChain= _host.keyChain!; // TODO check the existence of this keychain. A method is needed for keyChain loss and SSHClient onUserInfoRequest
    if (keyChain.Pem != null) keyPairs=SSHKeyPair.fromPem(keyChain.Pem!, keyChain.passphrase);


		final SSHClient client;
		try{
			client = SSHClient(
				socket,
				username: _host.user ,
				onPasswordRequest: () => keyChain.password, //totally fine if it is null
        identities: keyPairs,
				
			);
		}catch(e){
			final String message=e.toString();
			_exitCodeCompleter.complete(-1);
      _shortMessageCompleter.complete(message);
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

    IOSink outputlog=_logfile.openWrite(mode: FileMode.append);

		Stream<Uint8List> output = StreamGroup.merge([executor.stdout, executor.stderr]);
		output.forEach(
			(element) { //<---------------------------------------------  SUBSCRIBE TO OUTPUT
				outputlog.add(element.toList());
				data=utf8.decode(element);
				if (secondLine.length<secondLineLength){
					secondLine+=data;
				}

				print(data);

			}
		);

		await executor.done;
    final int exitCode=executor.exitCode!;
		_exitCodeCompleter.complete(exitCode);
		executor.close();
		
		await client.run("rm $tempath");
		client.close();

		
		await client.done;
		await socket.close();

		if (secondLine.length>secondLineLength){
					secondLine=secondLine.substring(0,secondLineLength);
				}
		firstLine+=exitCode.toString();
		
    _shortMessageCompleter.complete(firstLine+"\n"+secondLine.replaceAll("\n", " ")+"…");
		
	}
}


class ExecutorException implements Exception {
	final String msg;
	const ExecutorException(this.msg);
	@override
  String toString() => 'Executor Exception: $msg';
}

class InterpreterNotUnderstood extends ExecutorException{
	InterpreterNotUnderstood(String msg) : super(msg);
}