import 'package:flutter/material.dart';
import 'package:quiz_app/providers/score.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String category;
  final String difficulty;

  ResultScreen({
    required this.score,
    required this.total,
    required this.category,
    required this.difficulty,
  });

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ScoreManager _scoreManager;
  int? bestScore;

  @override
  void initState() {
    super.initState();
    _scoreManager = ScoreManager();
    _loadBestScore();
  }

  // Charger le meilleur score pour cette catégorie et difficulté
  void _loadBestScore() async {
    Map<String, int> scores = await _scoreManager.getScores();
    String key = "score_${widget.category}_${widget.difficulty}";
    
    setState(() {
      bestScore = scores[key];
    });
  }

  // Sauvegarder le score actuel
  void _saveCurrentScore() async {
    await _scoreManager.saveScore(widget.category, widget.difficulty, widget.score);
    _loadBestScore();  // Recharger les meilleurs scores après sauvegarde
  }

  // Réinitialiser les scores
  void _resetScores() async {
    await _scoreManager.resetScores();
    setState(() {
      bestScore = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Résultats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Votre score: ${widget.score} / ${widget.total}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            bestScore == null
                ? Text(
                    "Pas de score enregistré pour cette catégorie et difficulté.",
                    style: TextStyle(fontSize: 18),
                  )
                : Text(
                    "Meilleur score: $bestScore",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveCurrentScore,
              child: Text('Sauvegarder mon score'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetScores,
              child: Text('Réinitialiser les scores'),
            ),
          ],
        ),
      ),
    );
  }
}
