import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/view/add_edit_question_screen/add_question_screen.dart';
import '../../provider/quiz_provider.dart';
import 'question_detail_screen.dart';

class QuestionsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions List'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => AddQuestionScreen())),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: quizProvider.loadQuestions(), // Load questions
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error message
          }
          return ListView.builder(
            itemCount: quizProvider.questions.length,
            itemBuilder: (context, index) {
              final question = quizProvider.questions[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          question.text,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.deepPurple),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  QuestionDetailScreen(questionId: question.id),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
