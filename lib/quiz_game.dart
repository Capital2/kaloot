import 'dart:core';
import 'dart:math';
import 'package:kaloot/question_model.dart';
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
  late ValueChanged<Option> onClickedOption;
  int _curr = 0;
  bool lockOptions = false;
  List<Future<Question>> _questionList = [];
  int _correctAnswers = 0;
  int _currentQuestionIndex = 1;
  late final int _questions_length;
  _asyncMethod(int quizId) async {
    var ref = FirebaseDatabase.instance.ref("$quizId/game/questions_length");
    var snapshot = await ref.get();
    setState(() {
      _questions_length = snapshot.value as int;
    });
  }
  @override
  void initState() {
    super.initState();
    // _question = Question.create(_quizId, 0);
    // TODO to be changed
    WidgetsBinding.instance.addPostFrameCallback((_){
      _asyncMethod(_quizId);
    });
    // we use questions_length later
    _questionList = List.generate(1, (index) => Question.createAndPopulate(_quizId, index));

    onClickedOption = (option) {
      // onclickedoption callback
      if(lockOptions == false)
      {
        setState(() {
          option.isSelected = true;
          lockOptions = true;
          if(option.isRight!){
            _correctAnswers++;
          }
        });
      }
    };
  }
  @override
  Widget build(BuildContext context) {
    // 1 is already initialized
    for(int i = 1; i<_questions_length; i++)
      _questionList.add(Question.createAndPopulate(_quizId, i));
    _list = _questionList.map((question) => buildQuizGame(question)).toList();
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("level $_currentQuestionIndex"),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/quizBackground.jpg')
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  controller: controller,
                  onPageChanged: (num) {
                    setState(() {
                      _curr = num;
                    });
                  },
                  children: _list,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: !lockOptions ? null : () {
                        if(lockOptions) {
                          controller.nextPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                        }
                        setState(() {
                          lockOptions = false;
                          _currentQuestionIndex++;
                        });
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(143, 148, 251, 1),),
                      ),
                      child: const Text("Next", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),

                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Align(
                //     alignment: Alignment.centerRight,
                //     child: Text("Question ${snapshot.data.questionIndex + 1}",
                //     style: const TextStyle(fontSize: 25, color: Colors.white),),
                //   ),
                // ),
                const SizedBox(
                  height: 32,
                ),
                const Divider(
                  height: 10,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(snapshot.data.questionText,
                    style: TextStyle(fontSize: 30),),
                  ),
                ),
                optionsBuilder(options: snapshot.data.options)
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }
        });
  }


  Widget optionsBuilder( { required List<Option> options}){

    return Expanded(
      child: Scrollbar(
        thumbVisibility: true,

        child: SingleChildScrollView(
          child: Column(
            children: options.map((option) => singleOptionBuilder(
                option :option,
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget singleOptionBuilder({required Option option}){
    var color = lockOptions ? changeBorderColor(option) : Colors.purple;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => onClickedOption(option),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color, width: 2)
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(option.optionText!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color changeBorderColor(Option option){
    if(option.isRight!) {
      return Colors.green;
    }
    if(option.isSelected && !option.isRight!){
      return Colors.red;
    }
    return Colors.purple;
  }

  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz?'),
        content: const Text('All progress will be lost.'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:  const Text('Stay'),
          ),

          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            //return true when click on "Yes"
            child:Text('Continue'),
          ),

        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
}

class Player{
  String playerName;
  int score = 0;
  Player(this.playerName);
}