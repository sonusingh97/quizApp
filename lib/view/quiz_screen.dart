import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/view/result_screen.dart';
import '../provider/auth_provider.dart';
import '../provider/quiz_provider.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<QuizProvider>(context, listen: false).loadQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProviders = Provider.of<AuthProviders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.questions.isEmpty) {
            return const Center(
                child:
                    CircularProgressIndicator(color: Colors.deepPurpleAccent));
          }

          if (quizProvider.isQuizFinished) {
            quizProvider
                .saveScore(authProviders.user!.uid,
                    authProviders.user!.displayName.toString())
                .then((_) {
              quizProvider.fetchLatestScore(authProviders.user!.uid).then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen()),
                );
              });
            });

            return const Center(
                child: CircularProgressIndicator(
              color: Colors.deepPurpleAccent,
            ));
          }

          var question =
              quizProvider.questions[quizProvider.currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Question ${quizProvider.currentQuestionIndex + 1} of ${quizProvider.questions.length}',
                    style:
                        const TextStyle(fontSize: 18, color: Colors.deepPurple),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Text(
                    question.text,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: question.answers.map((answer) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.deepPurpleAccent,
                            backgroundColor: Colors.deepPurpleAccent,
                            padding: const EdgeInsets.all(16),
                            // Text color
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            quizProvider.answerQuestion(answer['isCorrect']);
                          },
                          child: Center(
                            child: Text(
                              answer['text'],
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
