// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:sshtm/Hosts/object_Host.dart';

class HostFormPage extends StatefulWidget {
  const HostFormPage(
    {
      Key? key,
      RemoteHost? toEdit
    }) :  _toEdit=toEdit,
          super(key: key);

  final RemoteHost? _toEdit;

  @override
  _HostFormPageState createState() =>_HostFormPageState();
}

class _HostFormPageState extends State<HostFormPage> {

  final GlobalKey<FormState> _formkey=GlobalKey<FormState>();
  String? _address;
  String? _name;
  String? _user;
  int? _port;
  String? _password;
  String? _oldPassword;

  void _destroyOldPassword(){
    setState(() {
      if (_oldPassword!=null)
        _oldPassword=null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _oldPassword=widget._toEdit?.keyChain?.password;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget._toEdit == null)
          ? const Text("Add new Host")
          : Text("Edit Host \""+widget._toEdit!.name+"\""),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                var _state = _formkey.currentState;
                if (_state != null && _state.validate()) {
                  _state.save();
                  RemoteHost result= RemoteHost(
                      name: _name!,
                      address: _address!,
                      port: _port!,
                      userLogin: _user!,
                      password: (_password != null && _password!.isNotEmpty) ? _password : _oldPassword,
                  );
                  
                  /*
                   * Cases study:
                   * 1) empty old password & empty new password: destroy not present, _password is null => return oldPassword which is null
                   * 2) empty old password & new password: return password
                   * 3) old password, empty new password: return oldPassword
                   * 4) old password, new password: return password
                   * 5) old password, press destroy and dont write a new password: password is null => return oldPassword which is null
                   * 6) old password, press destroy but write a new password: password is not null, return password
                   */

                  Navigator.pop(context, result);
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
                initialValue: widget._toEdit?.name,
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
                initialValue: widget._toEdit?.address,
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
                initialValue: widget._toEdit?.port.toString(),
                keyboardType: TextInputType.number,
                enableSuggestions: false,
                autocorrect: false,
                onSaved: ((newValue) {
                  if (newValue != null && newValue.isNotEmpty) {
                    int _temp = int.parse(newValue);
                    if (_temp >= 0 && _temp < 65536) _port = _temp;
                    print('porto $_temp cioè $_port');
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
                  if (_temp > 65535 || _temp < 0) return "Not a valid port number!";
                  else return null;
                }),
              ),
              TextFormField(
                initialValue: widget._toEdit?.user,
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
                enableIMEPersonalizedLearning: false,

                onSaved: ((newValue) {
                  _password = newValue;
                }),
                decoration: (_oldPassword == null) 
                  ? const InputDecoration(
                    labelText: 'Password',
                  )
                  : InputDecoration(
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "(unchanged)",
                    suffixIcon: IconButton(
                      onPressed: _destroyOldPassword,
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ),
                
              ),
            ]
          )
        )
      )
    );
  }
}
