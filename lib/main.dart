import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/SettingsProvider.dart';
import 'package:quiz_app/providers/app_localizations.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'providers/SettingsProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // Un seul provider
      ],
      child: MyApp(isDarkMode: isDarkMode),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({super.key, required this.isDarkMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  void toggleTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          // locale: settings.currentLocale, // Utilisation correcte de la locale
          // localizationsDelegates: [
          //   AppLocalizations.delegate,
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   Locale('en', 'US'),
          //   Locale('fr', 'FR'),
          //   Locale('ar', 'SA'),
          // ],
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            HomeScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        //  '/quiz': (context) => QuizScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode),
        // '/quiz': (context) => QuizScreen(),
        // '/result': (context) => ResultScreen(),
      },
  );
      },
    );
  }
}