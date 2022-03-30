import 'package:flutter/material.dart';

enum Page { Hosts, Scripts, Actions, Tasks, Logs }

class NavigableScaffold extends StatefulWidget {
  _navPageState createState() => _navPageState();
}

class _navPageState extends State<NavigableScaffold> {
  // THE STATES
  int selectedItem = 0;

  void gennaro(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  List<PreferredSizeWidget> ListaAppBars = <PreferredSizeWidget>[
    AppBar(
      title: Text('Hosts'),
    ),
    AppBar(
      title: Text("Scripts"),
    ),
    AppBar(
      title: Text('Actions'),
    ),
    AppBar(
      title: Text('Tasks'),
    ),
    AppBar(
      title: Text('Logs'),
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
              onTap: gennaro,
              currentIndex: selectedItem,
            )));
  }
}
