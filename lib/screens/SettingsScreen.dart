import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/SettingsProvider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Préférences',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Activer les sons'),
              value: Provider.of<SettingsProvider>(context).isSoundEnabled,
              onChanged: (value) {
                Provider.of<SettingsProvider>(context, listen: false).toggleSound(value);
              },
            ),
            SwitchListTile(
              title: Text('Activer les notifications'),
              value: Provider.of<SettingsProvider>(context).areNotificationsEnabled,
              onChanged: (value) {
                Provider.of<SettingsProvider>(context, listen: false).toggleNotifications(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}