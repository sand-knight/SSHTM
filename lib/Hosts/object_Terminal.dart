import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sshtm/Hosts/input_behavior_mymobile.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/frontend/input_behavior_desktop.dart';
import 'package:xterm/frontend/input_behavior_mobile.dart';
import 'package:xterm/xterm.dart';
import 'object_Host.dart';
import "package:pty/pty.dart";

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

class TerminalWidget extends StatefulWidget {
  final int _ID;
  final Host _host;
  final String _title;

  int getID() => _ID;

  Host getHost() => _host;

  String getTitle() => _title;

  TerminalWidget(this._ID, this._host, {Key? key})
      : _title = _host.getName() + " (" + _ID.toString() + ")",
        super(key: key);

  @override
  _TerminalWidgetState createState() => _TerminalWidgetState(_title, _host);
}

class _TerminalWidgetState extends State<TerminalWidget> {
  final String _title;
  final Terminal terminal;
  final Host _host;

  _TerminalWidgetState(this._title, this._host)
      : terminal = (_host is AndroidHost)
            ? Terminal(maxLines: 10000, backend: LocalTerminalBackend())
            : Terminal(
                maxLines: 10000,
                backend: LocalTerminalBackend()); // TODO RemoteTerminal

  @override
  void initState() {
    super.initState();
  }

  void onInput(String input) {
    /*semplice codice per capire se l'input è bufferizzato. Lo è, eppure non
  comprende backspace*/
    if (input.compareTo("r") == 0)
      print('input: no');
    else
      print('input: $input');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: SafeArea(
          child: TerminalView(
              terminal: terminal, inputBehavior: InputBehaviorSSHTM()),
        ));
  }
}
