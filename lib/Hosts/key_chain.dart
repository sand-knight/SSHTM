import 'package:hive/hive.dart';
part 'key_chain.g.dart';

@HiveType(typeId: 11, adapterName: "KeyChainAdapter")
class KeyChain extends HiveObject{

  @HiveField(0)
  final String? password;
  
  @HiveField(1)
  final String? Pem;

  @HiveField(2)
  final String? passphrase;

  KeyChain({String? password, String? Pem, String? passphrase}) : this.password=password,  this.Pem=Pem, this.passphrase=passphrase;
}
