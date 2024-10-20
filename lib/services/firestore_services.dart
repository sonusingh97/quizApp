import 'package:cloud_firestore/cloud_firestore.dart';


import '../model/question_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch questions
  Future<List<Question>> getQuestions() async {
    var snapshot = await _db.collection('questions').get();
    return snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
  }

  // Add a new question
  Future<void> addQuestion(Question question) async {
    await _db.collection('questions').add(question.toMap());
  }

  // Update an existing question
  Future<void> updateQuestion(String questionId, Question updatedQuestion) async {
    await _db.collection('questions').doc(questionId).update(updatedQuestion.toMap());
  }

  // Delete a question
  Future<void> deleteQuestion(String questionId) async {
    await _db.collection('questions').doc(questionId).delete();
  }
}
