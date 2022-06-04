import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sshtm/Hosts/object_key_chain.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:xterm/xterm.dart';
import "package:pty/pty.dart";

import 'package:dartssh2/dartssh2.dart';

class LocalTerminalBackend extends TerminalBackend {
  LocalTerminalBackend();

  final pty = PseudoTerminal.start(
    "/system/bin/sh",
    [],
    blocking: false,
    ackProcessed: true,
    environment: Platform.environment,
  );

  @override
  Future<int> get exitCode => pty.exitCode;

  @override
  void init() {
    pty.init();
  }

  @override
  Stream<String> get out => pty.out;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    pty.resize(width, height);
  }

  @override
  void write(String input) {
    pty.write(input);
  }

  @override
  void terminate() {}

  @override
  void ackProcessed() {}
}

class RemoteTerminalBackend extends TerminalBackend {
  final RemoteHost _host;
  late final SSHClient _client;
  late final SSHSession _shell;

  final _exitCodeCompleter = Completer<int>();
  final _outStream =
      StreamController<String>();

  RemoteTerminalBackend(this._host);

  void onWrite(String data) {
    _outStream.sink.add(data);
  }

  @override
  Future<int> get exitCode => _exitCodeCompleter.future;

  @override
  Future<void> init() async {
    final _sshOutput = StreamController<List<int>>();
    _sshOutput.stream.transform(utf8.decoder).listen(onWrite);

    onWrite('connecting to ' + _host.name + ':'+ (_host.port.toString()) + '...\n');

    /* Authentication data */
    List<SSHKeyPair>? keyPairs;
    final KeyChain keyChain= _host.keyChain!; // TODO check the existence of this keychain. A method is needed for keyChain loss and SSHClient onUserInfoRequest
    if (keyChain.Pem != null) keyPairs=SSHKeyPair.fromPem(keyChain.Pem!, keyChain.passphrase);

    /* init streams */
    final SSHSocket socket=await SSHSocket.connect(_host.address, _host.port, timeout: const Duration(seconds: 10));

    _client = SSHClient(
      socket,
      username: _host.user,
      onPasswordRequest: () => keyChain.password, // don't need to know whether password is null, because in that case it is skipped
      identities: keyPairs,
    );

    _shell = await _client.shell( //LateInitializationError: Field '_shell' has not been initialized
        pty: const SSHPtyConfig(
      type: 'xterm-256color',
    ));
  
    _sshOutput.addStream(_shell.stdout);
    _sshOutput.addStream(_shell.stderr);
  }

  @override
  Stream<String> get out => _outStream.stream;

  @override
  void resize(int width, int height, int pixelWidth, int pixelHeight) {
    _shell.resizeTerminal(width, height);
  }

  @override
  void write(String input) {
    _shell.write(Uint8List.fromList(utf8.encode(input)));
  }

  @override
  void terminate() {
    _shell.close();
  }

  @override
  void ackProcessed() {}
}
