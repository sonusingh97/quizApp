import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/question_model.dart';
import '../../provider/quiz_provider.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _questionText = '';
  List<Map<String, dynamic>> _answers = [];

  void _addAnswer() {
    if (_answers.length < 4) {
      setState(() {
        _answers.add({'text': '', 'isCorrect': false});
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add up to 4 answers.')),
      );
    }
  }

  void _removeAnswer(int index) {
    setState(() {
      _answers.removeAt(index);
    });
  }

  void _setCorrectAnswer(int index) {
    setState(() {
      for (var answer in _answers) {
        answer['isCorrect'] = false;
      }
      _answers[index]['isCorrect'] = true;
    });
  }

  void _submitForm() {
    if (_answers.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter exactly 4 answers.')),
      );
      return;
    }

    if (_answers.every((answer) => answer['text'].isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all answers.')),
      );
      return;
    }

    if (_answers.where((answer) => answer['isCorrect']).length != 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select exactly one correct answer.')),
      );
      return;
    }

    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final newQuestion = Question(
      id: '',
      text: _questionText,
      answers: _answers,
    );
    quizProvider.addQuestion(newQuestion);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Question'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the question and answers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Question Text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple[50],
                ),
                onChanged: (value) {
                  _questionText = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _answers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Answer ${index + 1}',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.deepPurple[50],
                                ),
                                onChanged: (value) {
                                  _answers[index]['text'] =
                                      value; // Update answer text
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter an answer';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Checkbox(
                              value: _answers[index]['isCorrect'],
                              onChanged: (bool? value) {
                                _setCorrectAnswer(
                                    index); // Only one answer can be correct
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => _removeAnswer(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _addAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Answer'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
