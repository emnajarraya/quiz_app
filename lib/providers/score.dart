import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  // Fonction pour récupérer les meilleurs scores
  Future<Map<String, int>> getScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> scores = {};

    // Récupérer les scores par catégorie et difficulté
    prefs.getKeys().forEach((key) {
      if (key.startsWith("score_")) {
        scores[key] = prefs.getInt(key)!;
      }
    });
    
    return scores;
  }

  // Fonction pour enregistrer un score
  Future<void> saveScore(String category, String difficulty, int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "score_${category}_$difficulty";
    await prefs.setInt(key, score);
  }

  // Fonction pour réinitialiser tous les scores
  Future<void> resetScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, int> scores = await getScores();

    scores.forEach((key, value) async {
      await prefs.remove(key);
    });
  }
}
