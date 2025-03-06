import 'package:flutter/material.dart';
import 'package:quiz_app/services/AudioService.dart';


class SettingsProvider with ChangeNotifier, WidgetsBindingObserver { 
   bool _isSoundEnabled = true;
  bool _areNotificationsEnabled = true;
  final AudioService _audioService = AudioService();

  bool get isSoundEnabled => _isSoundEnabled;
  bool get areNotificationsEnabled => _areNotificationsEnabled;

  void toggleSound(bool value) {
    _isSoundEnabled = value;
    if (_isSoundEnabled) {
      _audioService.playBackgroundMusic(); // Démarrer la musique si le son est activé
    } else {
      _audioService.stopBackgroundMusic(); // Arrêter la musique si le son est désactivé
    }
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    _areNotificationsEnabled = value;
    notifyListeners();
  }




   @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _audioService.stopBackgroundMusic(); // Arrêter la musique en arrière-plan
    } else if (state == AppLifecycleState.resumed && _isSoundEnabled) {
      _audioService.playBackgroundMusic(); // Redémarrer la musique si le son est activé
    }
  }

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.dispose();
    super.dispose();
  }
}