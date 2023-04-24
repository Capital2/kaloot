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
  List<Widget> _list = [];
  PageController controller = PageController();
  int _curr = 0;
  @override
  void initState() {
    super.initState();
    // _question = Question.create(_quizId, 0);
    // to be changed
    var lis = List.generate(1, (index) => Question.create(_quizId, index));
    _list = lis.map((question) => buildQuizGame(question)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("quiz"),
      ),
      body: PageView(
        allowImplicitScrolling: true,
        scrollDirection: Axis.horizontal,
        controller: controller,
        onPageChanged: (num) {
          setState(() {
            _curr = num;
          });
        },
        children: _list,
      ),
    );
  }

  Widget buildQuizGame(Future<Question> question){
    return FutureBuilder(
        future: question,
        builder: (context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("question ${snapshot.data.questionIndex}"),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Divider(
                  height: 10,
                ),
                optionsBuilder(options: snapshot.data.options)
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }


  Widget optionsBuilder( { required List<Option> options}){
    bool lockOptions = false;
    return Expanded(
      child: Column(
        children: options.map((option) => singleOptionBuilder(
            option :option,
            onClickedOption:  (option) {
              // onclickedoption callback
              if(lockOptions = false)
              {
                setState(() {
                  option.isSelected = true;
                  lockOptions = true;
                });
              }
            },
            lockOptions: lockOptions

        )).toList(),
      ),
    );
  }

  Widget singleOptionBuilder({required Option option, required ValueChanged<Option> onClickedOption, required bool lockOptions}){
    var color = lockOptions ? changeBorderColor(option) : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onClickedOption(option),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color)
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(option.optionText),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color changeBorderColor(Option option){
    if(option.isRight) {
      return Colors.green;
    }
    if(option.isSelected && !option.isRight){
      return Colors.red;
    }
    return Colors.black;
  }

}



class Question{

  late final String questionText;
  List<Option> options = [];
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
    // initialize options with index map the options texts
    for(int i = 0; i<dboptionlist.length; i++){
      question.options.add(Option(i, dboptionlist[i], i == correctQuestionIndex));
    }

    // Return the fully initialized object
    return question;
  }
}

class Option{
  final int optionIndex;
  final String optionText;
  final bool isRight;
  bool isSelected = false;

  /// Private constructor
  Option(this.optionIndex, this.optionText, this.isRight);

  /// Factory
  // static Future<Option> create(int questionIndex, DatabaseReference ref) async {
  //   var option = Option._create(questionIndex);
  //   return option;
  // }
}