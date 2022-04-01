import 'package:flutter/material.dart';

enum Page { Hosts, Scripts, Actions, Tasks, Logs }

class NavigableScaffold extends StatefulWidget {
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
    AppBar(
      title: const Text('Hosts'),
    ),
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
    Center(
        child: Container(
      child: const Text('Qua dentro stanno i server'),
    )),
    Center(
        child: Container(
      child: const Text('Qua dentro stanno gli script'),
    )),
    Center(
        child: Container(
      child: const Text('Qua dentro stanno le action'),
    )),
    Center(
        child: Container(
      child: const Text('Qua dentro stanno le task'),
    )),
    Center(
        child: Container(
      child: const Text('Qua dentro stanno i log'),
    )),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
            )));
  }
}
