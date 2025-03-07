import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/Widgets/DropdownCard.dart';
import 'package:quiz_app/Widgets/SliderCard.dart';
import 'package:quiz_app/providers/SettingsProvider.dart';
import 'package:quiz_app/providers/app_localizations.dart';
import 'package:quiz_app/screens/SettingsScreen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = "9";
  String selectedDifficulty = "medium";
  int selectedNumQuestions = 10;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      // settingsProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Définition des catégories et difficultés avec traduction
    final Map<String, String> categories = {
      "9": AppLocalizations.of(context)!.translate('category_9'),
      "18": AppLocalizations.of(context)!.translate('category_18'),
      "21": AppLocalizations.of(context)!.translate('category_21'),
      "23": AppLocalizations.of(context)!.translate('category_23'),
    };

    final Map<String, String> difficulties = {
      "easy": AppLocalizations.of(context)!.translate('difficulty_easy'),
      "medium": AppLocalizations.of(context)!.translate('difficulty_medium'),
      "hard": AppLocalizations.of(context)!.translate('difficulty_hard'),
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text( AppLocalizations.of(context)!.translate('quizSettings')), // 🔄 Traduction
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  SettingsScreen()),
              );
            },
          ),
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 100),
              DropdownCard(
                title: AppLocalizations.of(context)!.translate('chooseCategory'),
                value: selectedCategory,
                items: categories,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                icon: Icons.category,
              ),
              const SizedBox(height: 20),
              DropdownCard(
                title:  AppLocalizations.of(context)!.translate('chooseDifficulty'),
                value: selectedDifficulty,
                items: difficulties,
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
                icon: Icons.bar_chart,
              ),
              const SizedBox(height: 20),
              SliderCard(
                selectedNumQuestions: selectedNumQuestions,
                onChanged: (value) {
                  setState(() {
                    selectedNumQuestions = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        category: selectedCategory,
                        difficulty: selectedDifficulty,
                        numQuestions: selectedNumQuestions,
                        toggleTheme: widget.toggleTheme,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                child: Text( AppLocalizations.of(context)!.translate('chooseDifficulty'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
