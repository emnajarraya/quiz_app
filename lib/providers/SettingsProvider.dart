import 'package:flutter/material.dart';
import 'package:quiz_app/services/AudioService.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider with ChangeNotifier, WidgetsBindingObserver { 
   bool _isSoundEnabled = true;
  bool _areNotificationsEnabled = true;
  final AudioService _audioService = AudioService();

  bool get isSoundEnabled => _isSoundEnabled;
  bool get areNotificationsEnabled => _areNotificationsEnabled;

  String _locale = 'fr';


  SettingsProvider({String? initialLocale}) {
    _locale = initialLocale ?? 'fr';
  }

  String get locale => _locale;
  // Getters

  void setLocale(String locale) async {
    // _locale = locale;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale);
     _locale = locale;
    notifyListeners();
  }

  void initialize(String initialLocale) async {
     WidgetsBinding.instance.addObserver(this);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // _locale = prefs.getString('locale') ?? 'fr';
     _locale = initialLocale;
    notifyListeners();
     
  }
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

  // void initialize() {
  //   WidgetsBinding.instance.addObserver(this);
  // }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.dispose();
    super.dispose();
  }






}