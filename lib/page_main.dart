import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Hosts/widget_page_Host.dart';
import 'Hosts/bloc_Host.dart';
import "Hosts/object_Host.dart";

enum Page { Hosts, Scripts, Actions, Tasks, Logs }

class NavigableScaffold extends StatefulWidget {
  const NavigableScaffold({Key? key}) : super(key: key);

  @override
  _navPageState createState() => _navPageState();
}

class _navPageState extends State<NavigableScaffold> {
  // THE STATES
  int selectedItem = 0;

  void updateSelectedTab(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  List<PreferredSizeWidget> ListaAppBars = <PreferredSizeWidget>[
    hostsAppBar,
    AppBar(
      title: const Text("Scripts"),
    ),
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
    hostsBody,
    Center(child: const Text('Qua dentro stanno gli script')),
    Center(child: const Text('Qua dentro stanno le action')),
    Center(child: const Text('Qua dentro stanno le task')),
    Center(child: const Text('Qua dentro stanno i log')),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => cubit_Hosts(HostList()),
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
                ))));
  }
}
