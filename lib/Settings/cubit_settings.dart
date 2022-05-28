import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sshtm/Settings/object_settings_DataStruct.dart';
import 'package:sshtm/Settings/state_settings.dart';

class cubit_Settings extends Cubit<settingsState> {

  late final Settings _settings;
  bool _fullApp;

  factory cubit_Settings(bool fullApp) {
    return cubit_Settings._(fullApp, Settings());

  }
  cubit_Settings._(this._fullApp, Settings settings) : _settings=settings, super(settingsNotLoadedState(settings));
  

  Future<void> loadSettings() async {
    await _settings.retrieveData(_fullApp);
    emit (settingsLoadedState(_settings));
  }

}