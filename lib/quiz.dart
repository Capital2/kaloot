import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:kaloot/question_model.dart';
class QuizCreate extends StatefulWidget {
  const QuizCreate({Key? key}) : super(key: key);
  @override
  State<QuizCreate> createState() => _QuizCreateState();
}

class _QuizCreateState extends State<QuizCreate> {
  List<Question> _questions = List<Question>.generate(1,(index) => Question(questionIndex: index ,options: List<Option>.generate(2, (index) => Option(optionIndex: index))));
  int selectedRadio = 0;
  final GlobalKey<FormState> formKey = GlobalKey();
  void _submit() {

    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Publish quiz?'),
          // content: SingleChildScrollView(
          //   child: Column(
          //     children: <Widget>[
          //       const Align(
          //           alignment: Alignment.topLeft,
          //           child: Text("Question:",
          //               style: TextStyle(fontWeight: FontWeight.w700))),
          //       Align(
          //         alignment: Alignment.topLeft,
          //         child: Text(question.),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       const Align(
          //           alignment: Alignment.topLeft,
          //           child: Text("Answer:",
          //               style: TextStyle(fontWeight: FontWeight.w700))),
          //       Row(
          //         children: [
          //           Align(
          //             alignment: Alignment.topLeft,
          //             child: Text(answer1,
          //             style: TextStyle(color:(rightAnswer == 0 ? Colors.green : Colors.black)),),
          //           ),
          //           const SizedBox(width: 30,),
          //           Align(
          //             alignment: Alignment.topLeft,
          //             child: Text(answer2,
          //               style: TextStyle(color:(rightAnswer == 1 ? Colors.green : Colors.black)),),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    var quizId = (Random().nextInt(899999)+100000); // random 6 digit
                    DatabaseReference database = FirebaseDatabase.instance.ref("$quizId");
                    database.set({
                      "quiz":List<dynamic>.from(_questions.map((x) => x.toJson())),
                      "game":{
                        "players_joined": 0,
                        "current_question": 0,
                      }
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    // formKey.currentState?.reset();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizAdmin(quizId)),
                    );// Empty the form fields
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Create your quiz"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children:
              _questions.map((question) => buildQuestion(question)).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildQuestion(Question question){

    return Column(
      children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(" question",
              style: TextStyle(
                fontSize: 24,
              )),
        ),
        const SizedBox(
          height: 20,
        ),
        // Form normally
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Question',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide:
                    BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  border: OutlineInputBorder()),
              onFieldSubmitted: (value) {

                  question.questionText = value;
                  // firstNameList.add(firstName);

              },
              onChanged: (value) {

                  question.questionText = value;

              },
              validator: (value) {
                if (value == null || value.isEmpty || value.length < 3) {
                  return 'Question must contain at least 3 characters';
                } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                  return 'Question cannot contain special characters';
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Answer',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'this field must not be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {

                        question.options[0].optionText = value;
                        // lastNameList.add(lastName);
                    },
                    onChanged: (value) {

                        question.options[0].optionText = value;

                    },
                  ),
                ),
                Radio(
                  value: 0,
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value!;
                      for (var element in question.options) {
                        element.isRight = false;
                      }
                      question.options[0].isRight = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Answer',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                          BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ) {
                        return 'this field must not be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {

                        question.options[1].optionText = value;
                        // bodyTempList.add(bodyTemp);

                    },
                    onChanged: (value) {

                        question.options[1].optionText = value;

                    },
                  ),
                ),
                Radio(
                  value: 1,
                  groupValue: selectedRadio,
                  onChanged: (value) {
                    setState(() {
                      selectedRadio = value!;
                      for (var element in question.options) {
                        element.isRight = false;
                      }
                      question.options[1].isRight = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // DropdownButtonFormField(
            //     decoration: const InputDecoration(
            //         enabledBorder: OutlineInputBorder(
            //           borderRadius:
            //           BorderRadius.all(Radius.circular(20.0)),
            //           borderSide:
            //           BorderSide(color: Colors.grey, width: 0.0),
            //         ),
            //         border: OutlineInputBorder()),
            //     items: const [
            //       DropdownMenuItem(
            //         value: 0,
            //         child: Text("Answer 1"),
            //       ),
            //       DropdownMenuItem(
            //         value: 1,
            //         child: Text("Answer 2"),
            //       )
            //     ],
            //     hint: const Text("Correct answer"),
            //     onChanged: (value) {
            //       setState(() {
            //         rightAnswer = value!;
            //         // measureList.add(measure);
            //       });
            //     },
            //     onSaved: (value) {
            //       setState(() {
            //         rightAnswer = value!;
            //       });
            //     }),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60)),
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (formKey.currentState!.validate()) {
                  _submit();
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ],
    );
  }
}


class QuizAdmin extends StatefulWidget {
  QuizAdmin(int id, {super.key}){
    quizId = id;
  }
  late final int quizId;


  @override
  State<QuizAdmin> createState() => _QuizAdminState();
}

class _QuizAdminState extends State<QuizAdmin> {
  int _players = 0;
  @override
  Widget build(BuildContext context) {
    DatabaseReference playersref = FirebaseDatabase.instance.ref("${widget.quizId}/game/players_joined");
    playersref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      setState(() {
        _players = data as int;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("hey there admin"),
      ),
      body: Column(
        children: [
          Center(
            child: Text("your quiz id is ${widget.quizId}"),
          ),
          Center(
            child: Text("players joined: $_players"),
          )
        ],
      ),
    );
  }
}

