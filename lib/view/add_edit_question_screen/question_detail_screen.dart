import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/quiz_provider.dart';
import 'edit_question_screen.dart';


class QuestionDetailScreen extends StatelessWidget {
  final String questionId;

  QuestionDetailScreen({required this.questionId});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final question = quizProvider.questions.firstWhere((q) => q.id == questionId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question: ${question.text}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Answers:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...question.answers.map((answer) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(answer['text'], style: TextStyle(fontSize: 18)),
                      answer['isCorrect'] ? Icon(Icons.check, color: Colors.green) : SizedBox(),
                    ],
                  ),
                ),
              );
            }).toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit screen with the question details
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditQuestionScreen(question: question),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Edit Question'),
            ),
          ],
        ),
      ),
    );
  }
}
