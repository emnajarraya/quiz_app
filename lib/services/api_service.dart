import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question_model.dart';

class ApiService {
  static const String baseUrl = "https://opentdb.com/api.php";

  static Future<List<Question>> fetchQuestions(String category, String difficulty, int amount) async {
    final response = await http.get(Uri.parse("$baseUrl?amount=$amount&category=$category&difficulty=$difficulty&type=multiple"));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data["results"] as List).map((q) => Question.fromJson(q)).toList();
    } else {
      throw Exception("Erreur lors de la récupération des questions");
    }
  }
}
