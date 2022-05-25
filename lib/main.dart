import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sshtm/Hosts/key_chain.dart';
import 'page_main.dart';

void main() async{
  
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

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NavigableScaffold();
  }
}
