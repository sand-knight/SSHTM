import 'package:sshtm/Settings/object_settings_DataStruct.dart';

abstract class settingsState {
  final Settings _settings;
  Settings get settings => _settings;
  
  settingsState(this._settings);
}

class settingsNotLoadedState extends settingsState {
  settingsNotLoadedState(Settings settings) : super(settings);
}

class settingsLoadedState extends settingsState {
  settingsLoadedState(Settings settings) : super(settings);
}