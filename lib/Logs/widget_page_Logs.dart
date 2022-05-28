// ignore_for_file: curly_braces_in_flow_control_structures


import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text_viewer/model/text_viewer.dart';
import 'package:flutter_text_viewer/screen/text_viewer_page.dart';
import 'dart:io';
import 'package:sshtm/Settings/cubit_settings.dart';

class LogsAppBar extends StatelessWidget implements PreferredSizeWidget{
  const LogsAppBar({Key? key}) : super( key : key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){

    final Uri folderUrl=BlocProvider.of<cubit_Settings>(context).state.settings.logFolder.uri;
    return AppBar(
      title: const Text("Logs"),
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          onPressed: () async {
            final AndroidIntent intent = AndroidIntent(
              action: 'action_view',
              data: folderUrl.path,
              type: "*/*"
              );
              await intent.launch();
          },
          
          icon: const Icon(Icons.folder))
      ],
    );
  }
}


class LogBody extends StatefulWidget {
  const LogBody({Key? key}) : super(key: key);

  @override
  LogBodyState createState() => LogBodyState();
}

class LogBodyState extends State<LogBody> {

  late final Directory _logFolder=BlocProvider.of<cubit_Settings>(context).state.settings.logFolder;
  late Directory _currentFolder;
  late Future<List<FileSystemEntity>> _directorylist;

  @override
  void initState() {
    super.initState();

    _currentFolder=_logFolder;

    _loadFolder();
 

  }

  void changeFolder(Directory folder){
    setState(() {
      _currentFolder=folder;
      _loadFolder();
      }
    );
  }

  void _loadFolder() {

   /*the folder exists*/
    try {
      _directorylist = _currentFolder.list().toList();
    } catch (couldnotreadfoldercontent) {
      String incriminedPath=_currentFolder.path;
      print("Failed to load directory content at $incriminedPath");
      rethrow;
    }

  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: _directorylist,
      builder: (context, asyncsnapshot){
        if(!asyncsnapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
            );
        }
        else return Column( 
          children: [
            Card(
              child: ListTile(
                enabled: _currentFolder.path!=_logFolder.path,
                title: const Text("Up"),
                leading: const Icon(Icons.arrow_upward),
                onTap: () {
                  if (_currentFolder.path!=_logFolder.path){
                    changeFolder(_currentFolder.parent);
                  }
                }
              )
            ),
            Expanded(
              child: ListView.builder(
                itemCount: asyncsnapshot.data!.length,// _directorylist.length,
                itemBuilder: (context, index) {
                  FileSystemEntity element= asyncsnapshot.data!.elementAt(index);
                  if ( element is File )
                    return Card(
                      child: ListTile(
                        title: Text(element.path.split('/').last),
                        leading: const Icon(Icons.text_snippet),
                        trailing: const Icon(Icons.delete),
                        onTap: () async{
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context){
                                return TextViewerPage(
                                  textViewer: TextViewer.file(element.path),
                                  showSearchAppBar: true,
                                  );
                              }
                            ),
                          );
                        },
                      )
                    );
                  else if (element is Directory)
                    return Card(
                      child: ListTile(
                        title: Text(element.path.split('/').last),
                        leading: const Icon(Icons.folder),
                        trailing: const Icon(Icons.delete),
                        onTap: () => changeFolder(element),
                      )
                    );
                  else return Card(
                    child: ListTile(
                      title: Text(element.path.split('/').last),
                      leading: const Icon(Icons.question_mark)
                    )
                  );
                } ,
              )
            )
          ]
        );
      }
    );
  }
}