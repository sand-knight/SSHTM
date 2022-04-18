import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/object_terminal_data.dart';
import 'package:sshtm/Hosts/state_Host.dart';

class TerminalPage extends StatelessWidget {
  final TerminalData _data;
  const TerminalPage(this._data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_data.title),
        ),
        body: SafeArea(child:
            BlocBuilder<cubit_Hosts, hostsState>(builder: (context, state) {
          return _data.terminalView;
        })));
  }
}
