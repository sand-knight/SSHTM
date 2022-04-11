import 'object_Host.dart';

class Terminal {
  final int ID;
  final Host host;

  Terminal(this.ID, this.host);

  int getID() => ID;

  Host getHost() => host;

  /*Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(host.name + " (" + ID.toString() + ")"),
        ),
        body: Center(
          child: Text("this is a terminal"),
        ));
  }
  */
}
