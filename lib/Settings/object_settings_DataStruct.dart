import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_theme/json_theme.dart';
import 'package:path_provider/path_provider.dart';

import '../Hosts/key_chain.dart';

class Settings {



  late final ThemeData _theme;
  late final Directory _appData;
  late final Directory _logFolder;
  late final Map<String, bool> storageChoices={
    "hostsInStorage" : true,
    "hostsInFirebase" : false,
    "passwordsInHive" : true
  };

  Directory get appDataFolder => _appData;
  Directory get logFolder => _logFolder;
  ThemeData get theme => _theme;

  Future<void> retrieveData(bool fullApp) async {

    /* load settings which are needed also for minimal operation
     * like executing scripts from home widget
     */


    //needed for every data retrieval
    _appData = await getExternalStorageDirectory() as Directory;

    //------------------------------------------------------------------ HIVE - PASSWORDS
    //where password are stored
    await Hive.initFlutter();

    Hive.registerAdapter(KeyChainAdapter());

    /*
    * Open the key vault
    */
    const secureStorage=FlutterSecureStorage();
    String? unencryptedKey = await secureStorage.read(key: 'HiveVaultKey');
    
    if (unencryptedKey == null) {
      print("encryptionKey not found in secured storage");
      final newkey = Hive.generateSecureKey();
      unencryptedKey=base64Url.encode(newkey);
      await secureStorage.write(
        key: 'HiveVaultKey',
        value: unencryptedKey,
      );
    }
    print ("Key: "+unencryptedKey);
    final encryptionKey = base64Url.decode(unencryptedKey);
    await Hive.openBox<KeyChain>("keyVault", encryptionCipher: HiveAesCipher(encryptionKey));

    //------------------------------------------------------------------------------ LOGS
     /* initialize log folder */
    _logFolder = Directory.fromRawPath(
        Uint8List.fromList(utf8.encode(_appData.path + "/Logs")));

    
    /* folder does not exist: create it and exit, because it's empty*/
    if (!(await _logFolder.exists())) {
      
      try {
        _logFolder.create();
        return;
      } catch (couldnotcreatefolder) {
        String incriminedPath=_logFolder.path;
        print("Failed to create scripdir of path $incriminedPath");
        rethrow;
      }
    }

 
  
    if (fullApp){
      
      /* Data necessary for full fledged app, like themedata */
      //WidgetsFlutterBinding.ensureInitialized();

      //------------------------------------------------------------------------- THEME
      final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
      final themeJson = jsonDecode(themeStr);
      _theme = ThemeDecoder.decodeThemeData(themeJson)!;

    }

  }



}