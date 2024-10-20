import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String id;
  String text;
  List<Map<String, dynamic>> answers;

  Question({required this.id, required this.text, required this.answers});

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Question(
      id: doc.id,
      text: data['text'] ?? '',
      answers: List<Map<String, dynamic>>.from(data['answers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'answers': answers,
    };
  }
}
