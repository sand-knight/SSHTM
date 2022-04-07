import 'package:flutter/material.dart';

import 'object_Host.dart';

class Terminal {
  int ID;
  Host host;

  Terminal(this.ID, this.host);

  getID() => this.ID;
  getHost() => this.host;
}
