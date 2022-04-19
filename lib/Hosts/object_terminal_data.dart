import 'package:flutter/material.dart';
import 'package:sshtm/Hosts/input_behavior_mobile_keystrokes.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/object_terminal_backends.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

class TerminalData {
  late final Terminal _terminal;
  late final TerminalView _terminal_view;
  final int _ID;
  final Host _host;
  final String _title;

  TerminalData(this._ID, this._host, {Key? key})
      : _title = _host.name + " (" + _ID.toString() + ")" {
    _terminal = (_host is AndroidHost)
        ? Terminal(maxLines: 10000, backend: LocalTerminalBackend())
        : Terminal(
            //it's a remote host
            maxLines: 10000,
            backend: RemoteTerminalBackend(_host as RemoteHost));
    _terminal_view =
        TerminalView(terminal: terminal, inputBehavior: MyInputBehavior());
  }

  int get ID => _ID;
  Terminal get terminal => _terminal;
  TerminalView get terminalView => _terminal_view;
  Host get host => _host;

  String get title => _title;
}
