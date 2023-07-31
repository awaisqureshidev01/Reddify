import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:routemaster/routemaster.dart';

class ModtoolsScreen extends StatelessWidget {
  String name;
  ModtoolsScreen({super.key, required this.name});
  void navigateToAddMod(BuildContext context) {
    Routemaster.of(context).push('/add-mods/$name');
  }

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('/edit-community/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.add_moderator),
            title: Text('Add Moderators'),
            onTap: () => navigateToAddMod(context),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Community'),
            onTap: () {
              navigateToEditCommunity(context);
            },
          ),
        ],
      ),
    );
  }
}
