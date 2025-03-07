import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/SettingsProvider.dart';
import 'package:quiz_app/providers/app_localizations.dart';  // Assurez-vous d'importer les traductions

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings')),  // Traduction pour "Paramètres"
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('preferences'),  // Traduction pour "Préférences"
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            ListTile(
              title: Text(AppLocalizations.of(context)!.translate('language')),  // Traduction pour "language"
              trailing: DropdownButton<String>(
                value: Provider.of<SettingsProvider>(context).locale,
                onChanged: (String? newValue) {
                  Provider.of<SettingsProvider>(context, listen: false)
                      .setLocale(newValue!);
                },
                items: [
                  DropdownMenuItem(value: 'fr', child: Text(AppLocalizations.of(context)!.translate('french'))),  // Traduction pour "Français"
                  DropdownMenuItem(value: 'en', child: Text(AppLocalizations.of(context)!.translate('english'))),  // Traduction pour "English"
                  DropdownMenuItem(value: 'ar', child: Text(AppLocalizations.of(context)!.translate('arabic'))),  // Traduction pour "العربية"
                ],
              ),
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.translate('enableSounds')),  // Traduction pour "Activer les sons"
              value: Provider.of<SettingsProvider>(context).isSoundEnabled,
              onChanged: (value) {
                Provider.of<SettingsProvider>(context, listen: false).toggleSound(value);
              },
            ),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.translate('enableNotifications')),  // Traduction pour "Activer les notifications"
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
