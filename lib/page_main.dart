

// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Hosts/object_Host.dart';
import 'package:sshtm/Hosts/widget_page_Host.dart';
import 'package:sshtm/Logs/widget_page_Logs.dart';
import 'package:sshtm/Scripts/cubit_Scripts.dart';
import 'package:sshtm/Scripts/object_Script.dart';
import 'package:sshtm/Scripts/widget_page_Scripts.dart';
import 'package:sshtm/Settings/cubit_settings.dart';
import 'package:sshtm/Settings/state_settings.dart';
import 'Hosts/bloc_Host.dart';
import "package:fluttertoast/fluttertoast.dart";


enum Page { Hosts, Scripts, Actions, Tasks, Logs }

class NavigableScaffold extends StatefulWidget {
  const NavigableScaffold({Key? key}) : super(key: key);

  @override
  _navPageState createState() => _navPageState();
}

class _navPageState extends State<NavigableScaffold> {
  // THE STATES
  int selectedItem = 0;
  final GlobalKey<LogBodyState> _LogKey=GlobalKey<LogBodyState>();
  late  final List<PreferredSizeWidget> AppBarsList;
  late final List<Widget> BodiesList;

  void setListenExecutionEvents( Stream<ExecutionEvent> eventStream){
    eventStream.forEach(
      (e) {
        if (e is JobReturned_ExecutionEvent) {
          
          /* Send a toast notification */
          Fluttertoast.showToast(  
            msg: e.shortMessage,
            toastLength: Toast.LENGTH_LONG,
          );
          
          /* Notify the logs body that a log might have been created on JobReturned */
          if(_LogKey.currentState != null)
            if(_LogKey.currentState!.mounted )
              _LogKey.currentState!.didChangeDependencies();
        }
      }
    );
  }

  void updateSelectedTab(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  void initState(){
    super.initState();
    AppBarsList = <PreferredSizeWidget>[
      const hostsAppBar(),
      const scriptsAppBar(),
      AppBar(
        title: const Text('Actions'),
      ),
      AppBar(
        title: const Text('Tasks'),
      ),
      const LogsAppBar()
    ];

    BodiesList = <Widget>[
      const hostsBody(),
      const scriptsBody(),
      const Center(child: Text('Qua dentro stanno le action')),
      const Center(child: Text('Qua dentro stanno le task')),
      LogBody(key: _LogKey),
  ];


  }


  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context) => cubit_Settings(true),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => cubit_Hosts(HostList(BlocProvider.of<cubit_Settings>(context))),
          ),
          BlocProvider(
            create: (context) => cubit_Scripts(ScriptList(BlocProvider.of<cubit_Settings>(context))),
          ),
          BlocProvider(
            create: (context) {
              final bloc_Execution bloc = bloc_Execution();
              //listen to execution events to send toasts
              setListenExecutionEvents(bloc.eventStream);
              return bloc;},
          )
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: BlocBuilder<cubit_Settings, settingsState>(
          builder: (context, state) {
            if (state is settingsNotLoadedState){
              BlocProvider.of<cubit_Settings>(context).loadSettings(); 
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Center(
                      child: Text(
                        "SplashScreen Here",
                        textAlign:TextAlign.center,
                        textScaleFactor: 0.8,
                        style: TextStyle(
                          color: Colors.white,
                        )
                        ),
                      
                    )
                  ],
                
              );
            }
            else return
          Scaffold(
                appBar: (AppBarsList.elementAt(selectedItem)),
                body: BodiesList.elementAt(selectedItem),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.monitor),
                      label: "Hosts",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.insert_drive_file),
                      label: "Scripts",
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.bolt), label: "Actions"),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pending_actions),
                      label: "Tasks",
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.book), label: "Logs"),
                  ],
                  onTap: updateSelectedTab,
                  currentIndex: selectedItem,
                )
            );
          }
          )
          )
            )
    );
  }
}
