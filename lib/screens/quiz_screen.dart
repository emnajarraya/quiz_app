import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/providers/app_localizations.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/api_service.dart';
import 'dart:async'; // Import pour le Timer

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;
  final int numQuestions;
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  QuizScreen(
      {required this.category,
      required this.difficulty,
      required this.numQuestions,
      required this.toggleTheme,
      required this.isDarkMode});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;
  late Timer _timer; // Déclare un Timer
  int _timeLeft = 10; // Temps initial de 10 secondes pour chaque question

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  void fetchQuestions() async {
    questions = await ApiService.fetchQuestions(
        widget.category, widget.difficulty, widget.numQuestions);
    setState(() {
      isLoading = false;
    });
    _startTimer(); // Démarre le timer dès que les questions sont chargées
  }

  // Démarre le timer de 10 secondes
  void _startTimer() {
    _timeLeft = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _nextQuestion(); // Passe à la question suivante après 5 secondes
        }
      });
    });
  }

  // Vérifier la réponse et passer à la question suivante
  void checkAnswer(String answer) {
    if (_timer.isActive) {
      _timer.cancel(); // Arrêter le timer dès qu'une réponse est donnée
    }
    if (questions[currentIndex].correctAnswer == answer) {
      score++;
    }
    _nextQuestion();
  }

  // Passer à la question suivante
  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        _startTimer(); // Redémarre le timer pour la question suivante
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: questions.length,
            category: widget.category,
            difficulty: widget.difficulty,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('quiz'),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purpleAccent,
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Affichage du numéro de la question
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${AppLocalizations.of(context)!.translate('question')} ${currentIndex + 1} ${AppLocalizations.of(context)!.translate('of')} ${questions.length}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Affichage du timer
              Text(
                "Temps restant: $_timeLeft",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Affichage de la question avec un fond arrondi
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    questions[currentIndex].question,
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Affichage des options sous forme de boutons
              ...questions[currentIndex].options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    width: double
                        .infinity, // Cela permet aux boutons de prendre toute la largeur disponible
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text(option,
                          textAlign:
                              TextAlign.center), // Texte centré dans le bouton
                    ),
                  ),
                );
              }).toList(),
              Spacer(),
              // Affichage du score en bas
              Center(
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('score'),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      "$score", // Assurez-vous que la variable score est une chaîne ici
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
