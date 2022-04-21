import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Hosts/Terminal/object_terminal_data.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/object_Host.dart';

class NewHostPage extends StatelessWidget {
  NewHostPage({Key? key}) : super(key: key) {
    _formkey = GlobalKey<FormState>();
    _theForm = newHostForm(_formkey);
  }

  late final _formkey;
  late final _theForm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add new Host"), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              var _state = _formkey.currentState;
              if (_state != null && _state.validate()) {
                _state.save();
                List _formResult = _theForm.formData;
                BlocProvider.of<cubit_Hosts>(context).addHost(RemoteHost(
                    _formResult[0],
                    _formResult[1],
                    _formResult[2],
                    _formResult[3],
                    _formResult[4]));
                print('Ho aggiunto $_formResult');
                Navigator.pop(context);
                _formkey.dispose();
                _theForm.dispose();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Invalid data provided",
                      textAlign: TextAlign.center,
                    ),
                  )
                );
              }
            },
          )
        ]),
        body: Padding(padding: const EdgeInsets.all(8), child: _theForm));
  }
}

class newHostForm extends StatefulWidget {
  newHostForm(this.innerFormKey, {Key? key}) : super(key: key);

  final Key innerFormKey;
  late final _newHostFormState _localStateReference;

  List get formData => _localStateReference.formData;

  @override
  _newHostFormState createState() {
    _localStateReference = _newHostFormState(innerFormKey);
    return _localStateReference;
  }
}

class _newHostFormState extends State<newHostForm> {
  _newHostFormState(this.innerFormKey);
  String? _address;
  String? _name;
  String? _user;
  int? _port;
  String? _password;
  final Key innerFormKey;

  List get formData => [_name, _address, _port, _user, _password];

  @override
  Widget build(BuildContext context) {
    return Form(
        key: innerFormKey,
        child: Column(children: <Widget>[
          TextFormField(
            onSaved: ((newValue) {
              _name = newValue;
            }),
            decoration: const InputDecoration(
              labelText: 'Display name',
            ),
            validator: ((newValue) {
              return null;
            }),
          ),
          TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            onSaved: ((newValue) {
              _address = newValue;
            }),
            decoration: const InputDecoration(
              labelText: 'Address',
            ),
            validator: ((newValue) {
              return null;
            }),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            enableSuggestions: false,
            autocorrect: false,
            onSaved: ((newValue) {
              // ignore: curly_braces_in_flow_control_structures
              if (newValue != null) {
                int _temp = int.parse(newValue);
                if (_temp >= 0 && _temp < 65536) _port = _temp;
                print('porto $_temp cioè $_port');
                // ignore: curly_braces_in_flow_control_structures
              }
              else {
                _port = 0;
                print('porto zero perché newValue==null');
              }
            }),
            decoration: const InputDecoration(
              labelText: 'Port',
            ),
            validator: ((newValue) {
              if (newValue != null) {
                int _temp = int.parse(newValue);
                if (_temp > 65535 || _temp < 0)
                  return "Not a valid port number!";
              }
              return null;
            }),
          ),
          TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            onSaved: ((newValue) {
              _user = newValue;
            }),
            decoration: const InputDecoration(
              labelText: 'Login Username',
            ),
            validator: ((newValue) {
              return null;
            }),
          ),
          TextFormField(
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            onSaved: ((newValue) {
              _password = newValue;
            }),
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            validator: ((newValue) {
              return null;
            }),
          ),
        ]));
  }
}
