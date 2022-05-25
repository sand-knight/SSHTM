import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/bloc_Host.dart';
import 'package:sshtm/Terminal/object_terminal_data.dart';
import 'package:sshtm/Hosts/state_Host.dart';
import 'package:sshtm/Hosts/object_Host.dart';

class NewHostPage extends StatefulWidget {
  NewHostPage({Key? key}) : super(key: key);


  @override
  _newHostFormState createState() =>_newHostFormState();
}

class _newHostFormState extends State<NewHostPage> {

  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  String? _address;
  String? _name;
  String? _user;
  int? _port;
  String? _password;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Host"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                var _state = _formkey.currentState;
                if (_state != null && _state.validate()) {
                  _state.save();
                  BlocProvider.of<cubit_Hosts>(context).addHost(
                    RemoteHost(
                      name: _name!,
                      address: _address!,
                      port: _port!,
                      userLogin: _user!,
                      password: _password
                    )
                  );
                  Navigator.pop(context);
                  _state.dispose();
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
          ]
        ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _formkey, // <------ the key!
          child: Column(
            children: <Widget>[
              TextFormField(
                onSaved: ((newValue) {
                  _name = newValue;
                }),
                decoration: const InputDecoration(
                  labelText: 'Display name',
                ),
                validator: ((newValue) {
                  if (newValue==null || newValue.isEmpty)
                    return "describe this host";
                  else return null;
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
                  if (newValue==null || newValue.isEmpty)
                    return "I do need an address";
                  else return null;
                }),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                autocorrect: false,
                onSaved: ((newValue) {
                  // ignore: curly_braces_in_flow_control_structures
                  if (newValue != null && newValue.isNotEmpty) {
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
                  if (newValue == null || newValue.isEmpty) return "Needed data";
                  int _temp = int.parse(newValue);
                  if (_temp > 65535 || _temp < 0)
                    return "Not a valid port number!";
                  else return null;
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
                  if (newValue==null || newValue.isEmpty)
                    return "uname";
                  else return null;
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
                  if (newValue==null || newValue.isEmpty)
                    return "For now I need a password";
                  else return null;
                }),
              ),
            ]
          )
        )
      )
    );
  }
}
