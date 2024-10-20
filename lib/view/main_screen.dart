import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quizapp/view/add_edit_question_screen/question_list_screen.dart';

import '../provider/auth_provider.dart';

import '../provider/quiz_provider.dart';
import 'quiz_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProviders = Provider.of<AuthProviders>(context, listen: false);
      final quizProvider = Provider.of<QuizProvider>(context, listen: false);

      if (authProviders.user != null) {
        quizProvider.fetchLatestScore(authProviders.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MCQ Quiz'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => QuestionsListScreen()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: Center(
        child: quizProvider.latestScore == null
            ? ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding:
            const EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Colors.deepPurple, // background color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => QuizScreen()));
          },
          child: const Text(
            'Start New Quiz',
            style: TextStyle(fontSize: 18),
          ),
        )// Show loading indicator while fetching score
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Text(
                              'Your Previous Score',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              quizProvider.latestScore != null
                                  ? '${quizProvider.latestScore}'
                                  : 'No scores available yet.',
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: Colors.deepPurple, // background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => QuizScreen()));
                    },
                    child: const Text(
                      'Start New Quiz',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
