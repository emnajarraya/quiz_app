import 'package:flutter/material.dart';
import '../models/question_model.dart';
import '../services/api_service.dart';

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool get isLoading => _isLoading;

  Future<void> fetchQuestions(String category, String difficulty, int amount) async {
    _isLoading = true;
    notifyListeners();

    try {
      _questions = await ApiService.fetchQuestions(category, difficulty, amount);
      _currentIndex = 0;
      _score = 0;
      _isLoading = false;
    } catch (e) {
      _isLoading = false;
      print("Erreur : $e");
    }

    notifyListeners();
  }

  void checkAnswer(String selectedAnswer) {
    if (_questions[_currentIndex].correctAnswer == selectedAnswer) {
      _score++;
    }
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
    }
    notifyListeners();
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    notifyListeners();
  }
}
