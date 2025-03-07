import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/SettingsProvider.dart';
import 'package:quiz_app/providers/quiz_provider.dart';
import 'package:quiz_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiz_app/providers/app_localizations.dart'; // Assurez-vous du bon chemin

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final String initialLocale = prefs.getString('locale') ?? 'fr';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(initialLocale: initialLocale),
        ),
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

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkMode', value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        final bool isArabic = settings.locale == 'ar';

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quiz App',
            locale: Locale(settings.locale),
            supportedLocales: const [
              Locale('fr'),
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              fontFamily: isArabic ? 'Tajawal' : 'Roboto',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: isArabic ? 'Tajawal' : 'Roboto',
            ),
            themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: {
              '/': (context) => HomeScreen(
                    toggleTheme: toggleTheme,
                    isDarkMode: isDarkMode,
                  ),
            },
          ),
        );
      },
    );
  }
}
