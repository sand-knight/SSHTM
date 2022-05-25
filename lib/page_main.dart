

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Executor/bloc_Jobs.dart';
import 'package:sshtm/Executor/events_Execution.dart';
import 'package:sshtm/Hosts/widget_page_Host.dart';
import 'package:sshtm/Scripts/cubit_Scripts.dart';
import 'package:sshtm/Scripts/widget_page_Scripts.dart';
import 'Hosts/bloc_Host.dart';
import "Hosts/object_Host.dart";
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

  void setListenExecutionEvents( Stream<ExecutionEvent> eventStream){
    eventStream.forEach(
      (e) {
        if (e is JobReturned_ExecutionEvent) {
          Fluttertoast.showToast(  
            msg: e.shortMessage,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      }
    );
  }

  void updateSelectedTab(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  List<PreferredSizeWidget> ListaAppBars = <PreferredSizeWidget>[
    const hostsAppBar(),
    const scriptsAppBar(),
    AppBar(
      title: const Text('Actions'),
    ),
    AppBar(
      title: const Text('Tasks'),
    ),
    AppBar(
      title: const Text('Logs'),
    )
  ];

  List<Widget> ListaDeiCorpi = <Widget>[
    hostsBody(),
    scriptsBody(),
    Center(child: const Text('Qua dentro stanno le action')),
    Center(child: const Text('Qua dentro stanno le task')),
    Center(child: const Text('Qua dentro stanno i log')),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => cubit_Hosts(),
          ),
          BlocProvider(
            create: (context) => cubit_Scripts(),
          ),
          BlocProvider(
            create: (context) {
              final bloc_Execution bloc = bloc_Execution();
              setListenExecutionEvents(bloc.eventStream);
              return bloc;},
          )
        ],
        child: MaterialApp(
            theme: ThemeData.dark(),
            title: 'Ciao',
            home: Scaffold(
                appBar: (ListaAppBars.elementAt(selectedItem)),
                body: ListaDeiCorpi.elementAt(selectedItem),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.monitor),
                      label: "Hosts",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.text_snippet),
                      label: "Scripts",
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.bolt), label: "Actions"),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pending_actions),
                      label: "Tasks",
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.event_note), label: "Logs"),
                  ],
                  onTap: updateSelectedTab,
                  currentIndex: selectedItem,
                )
            )
          )
    );
  }
}
