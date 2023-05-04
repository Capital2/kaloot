import 'dart:core';
import 'dart:math';
import 'package:kaloot/question_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class QuizGame extends StatefulWidget{
  const QuizGame({super.key, required this.quizId, required this.playerName});
  final int quizId;
  final String playerName;

  @override
  State<QuizGame> createState() => _QuizGameState(quizId, playerName);
}

class _QuizGameState extends State<QuizGame> {
  _QuizGameState(this._quizId, this._playerName);
  Player _player = Player();
  late final int _quizId;
  late final String _playerName;
  List<Widget> _list = [];
  PageController controller = PageController();
  late ValueChanged<Option> onClickedOption;
  int _curr = 0;
  bool lockOptions = false;
  List<Future<Question>> _questionList = [];
  int _correctAnswers = 0;
  int _currentQuestionIndex = 1;
  late final Future<DataSnapshot> _questions_length;
  int _questions_length_int = 0;


  @override
  void initState() {
    super.initState();
    _player.playerName = _playerName;
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await showDialog<String>(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: const Text('Exit Quiz?'),
    //         content: const Text('All progress will be lost.'),
    //         actions:[
    //           ElevatedButton(
    //             onPressed: () => Navigator.of(context).pop(false),
    //             //return false when click on "NO"
    //             child:  const Text('Stay'),
    //           ),
    //
    //           ElevatedButton(
    //             onPressed: () => Navigator.of(context).pop(true),
    //             //return true when click on "Yes"
    //             child:Text('Continue'),
    //           ),
    //
    //         ],
    //       ),
    //   );
    // });

    var ref = FirebaseDatabase.instance.ref("$_quizId/game/questions_length");
    var snapshot = ref.get();
    _questions_length = snapshot;
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
    for(int i = _questionList.length; i<_questions_length_int; i++) {
      _questionList.add(Question.createAndPopulate(_quizId, i));
    }
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
          child: FutureBuilder(
            future: _questions_length,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData && snapshot.data.value != null) {
                _questions_length_int = snapshot.data.value ;
              return Column(
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
                  // Padding(
                  //   padding: const EdgeInsets.all(17.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       ElevatedButton(
                  //         onPressed: !lockOptions ? null : () {
                  //           if (lockOptions) {
                  //             controller.nextPage(
                  //                 duration: const Duration(milliseconds: 200),
                  //                 curve: Curves.easeIn);
                  //           }
                  //           setState(() {
                  //             lockOptions = false;
                  //             _currentQuestionIndex++;
                  //           });
                  //         },
                  //         style: const ButtonStyle(
                  //           backgroundColor: MaterialStatePropertyAll<Color>(
                  //             Color.fromRGBO(143, 148, 251, 1),),
                  //         ),
                  //         child: const Text("Next", style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 20),),
                  //
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 30)
                ],
              );
            }
              else{
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
                }
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
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: CircularCountDownTimer(
                          autoStart: true,
                          duration: 10,
                          initialDuration: 0,
                          controller: CountDownController(),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 2,
                          ringColor: Colors.grey[300]!,
                          ringGradient: null,
                          fillColor: Colors.purpleAccent[100]!,
                          fillGradient: null,
                          backgroundColor: Colors.purple[500],
                          backgroundGradient: null,
                          strokeWidth: 20.0,
                          strokeCap: StrokeCap.round,
                          textStyle: const TextStyle(
                              fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
                          textFormat: CountdownTextFormat.S,
                          isReverse: false,
                          isReverseAnimation: false,
                          isTimerTextShown: false,
                          onStart: () {
                            debugPrint('Countdown Started');
                          },
                          onComplete: () {
                            if(_curr == _questions_length_int -1 )
                              {
                                // finished quiz
                                // pop the quiz
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShowFinalScore(_player.score)),
                                );
                              }
                            controller.nextPage(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                            setState(() {
                              lockOptions = false;
                              _currentQuestionIndex++;
                            });
                          },
                          onChange: (String timeStamp) {
                            debugPrint('Countdown Changed $timeStamp');
                          },
                          timeFormatterFunction: (defaultFormatterFunction, duration) {
                            return snapshot.data.questionText;
                          },
                        ),
                      ),
                      Align(
                      alignment: Alignment.center,
                      child: Text(snapshot.data.questionText,
                      style: const TextStyle(fontSize: 30),),
                      ),

                    ]
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
        // thumbVisibility: true,
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
      if (option.isSelected!){
        _player.updateScore(10);
      }
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

class ShowFinalScore extends StatelessWidget {
  const ShowFinalScore(this.score ,{super.key});

  final int score;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text("Final score"),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/quizBackground.jpg')
            )
        ),
        child: Center(
          child: Column(
 mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Your final score: $score",
              style: const TextStyle(fontSize: 24),),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromRGBO(143, 148, 251, 1),),
                ),
                child: const Text("return", style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),),

              ),
            ],

          ),
        ),
      ),
    );
  }

}



class Player{
  String? playerName;
  int score = 0;
  Player({this.playerName}){
    _updateDatabase(0);
  }

  void _updateDatabase(int score){
    DatabaseReference database = FirebaseDatabase.instance.ref("game");
    database.set({
      playerName: score,
    });
  }
  void updateScore(int timeStampInSec){
    // given that every question lasts 10 sec
    score += timeStampInSec*10;
    _updateDatabase(score);
  }
}