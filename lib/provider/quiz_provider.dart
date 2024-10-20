import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/question_model.dart';
import '../services/firestore_services.dart';
class QuizProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<Question> get questions => _questions;

  int get currentQuestionIndex => _currentQuestionIndex;

  int get score => _score;

  Future<void> loadQuestions() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    _questions =
        snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> addQuestion(Question question) async {
    await _firestoreService.addQuestion(question);
    _questions.add(question);
    await loadQuestions();
    notifyListeners();
  }

  Future<void> updateQuestion(
      String questionId, Question updatedQuestion) async {
    await _firestoreService.updateQuestion(questionId, updatedQuestion);

    final index = _questions.indexWhere((q) => q.id == questionId);
    if (index != -1) {
      _questions[index] = updatedQuestion;
      await loadQuestions();
      notifyListeners();
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    await _firestoreService.deleteQuestion(questionId);
    // Remove from local state
    _questions.removeWhere((q) => q.id == questionId);
    notifyListeners();
  }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      _score++;
    }
    _currentQuestionIndex++;
    notifyListeners();
  }

  int? latestScore;

  bool get isQuizFinished => _currentQuestionIndex >= _questions.length;

  Future<void> saveScore(String userId, String userName) async {
    await FirebaseFirestore.instance.collection('scores').add({
      'userId': userId,
      'userName': userName,
      'score': _score,
      'quizDate': DateTime.now(),
    });
  }

  Future<void> fetchLatestScore(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('scores')
          .where('userId', isEqualTo: userId)
          .orderBy('quizDate', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        latestScore = snapshot.docs.first['score'];
        print("Latest score fetched: $latestScore");
      } else {
        latestScore = null;
        print("No scores found for user: $userId");
      }
    } catch (e) {
      print("Error fetching latest score: $e");
      latestScore = null;
    }

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    notifyListeners();
  }
}
