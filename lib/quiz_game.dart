import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class QuizGame extends StatefulWidget{
  const QuizGame({super.key, required this.quizId});
  final int quizId;

  @override
  State<QuizGame> createState() => _QuizGameState(quizId);
}

class _QuizGameState extends State<QuizGame> {
  _QuizGameState(this._quizId);
  late final int _quizId;
  late var _question;
  @override
  void initState() {
    super.initState();
    _question = Question.create(_quizId, 0);
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
        future: _question,
        builder: (context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {
            return buildQuizGame(snapshot.data);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
  
  Widget buildQuizGame(Question question){
    return Scaffold(
      appBar: AppBar(
        title: const Text("quiz"),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text("question no..."),
          ),
          SizedBox(
            height: 32,
          ),
          Divider(
            height: 10,
          ),
          PageView.builder(
              itemBuilder: optionsBuilder(question),
              controller: quizController,),
        ],
      ),
    );
  }
}

Widget optionsBuilder(Question question){
  return Column(
    children: [
      question.options.map((option) => singleOptionbuilder())
    ],
  )
}

class Question{

  late final String questionText;
  late List<Option> options;
  late final int quizId;
  late final int questionIndex;

  /// Private constructor
  Question._create(this.quizId, this.questionIndex);

  /// Public factory
  static Future<Question> create(int quizId, int questionIndex) async {
    var question = Question._create(quizId, questionIndex);
    
    final ref = FirebaseDatabase.instance.ref("$quizId/quiz/$questionIndex");
    var snapshot = await ref.child("question").get();
    question.questionText = snapshot.exists ? snapshot.value as String : "no data for this field";

    snapshot = await ref.child("correctAnswerIndex").get();
    int correctQuestionIndex = snapshot.exists ? snapshot.value as int : 0;

    snapshot = await ref.child("answers").get();
    var dboptionlist = snapshot.value as List;
    // initialize options with index
    for(int i = 0; i<dboptionlist.length; i++){
      question.options.add(Option._create(i));
    }
    // map the options texts
    question.options.map((option) {
      option.optionText = dboptionlist[option.optionIndex];
      option.isRight = option.optionIndex == correctQuestionIndex;
    });
    // Return the fully initialized object
    return question;
  }
}

class Option{
  final int optionIndex;
  late final String optionText;
  late final bool isRight;
  bool isSelected = false;

  /// Private constructor
  Option._create(this.optionIndex);

  /// Factory
  static Future<Option> create(int questionIndex, DatabaseReference ref) async {
    var option = Option._create(questionIndex);


    return option;
  }
}