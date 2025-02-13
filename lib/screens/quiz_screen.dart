import 'package:flutter/material.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/services/api_service.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;
  final int numQuestions;
    final Function(bool) toggleTheme;
  final bool isDarkMode;

  QuizScreen({
    required this.category,
    required this.difficulty,
    required this.numQuestions,
     required this.toggleTheme, required this.isDarkMode
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [];
  int currentIndex = 0;
  int score = 0;
  bool isLoading = true;

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
  }

  void checkAnswer(String answer) {
    if (questions[currentIndex].correctAnswer == answer) {
      score++;
    }
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
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
        title: Text("Quiz", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                  "Question ${currentIndex + 1} sur ${questions.length}",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
                    width: double.infinity, // Cela permet aux boutons de prendre toute la largeur disponible
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      child: Text(option, textAlign: TextAlign.center), // Texte centré dans le bouton
                    ),
                  ),
                );
              }).toList(),
              Spacer(),
              // Affichage du score en bas
              Center(
                child: Text(
                  "Score: $score",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
