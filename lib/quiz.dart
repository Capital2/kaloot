import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class QuizCreate extends StatefulWidget {
  const QuizCreate({Key? key}) : super(key: key);
  @override
  State<QuizCreate> createState() => _QuizCreateState();
}

class _QuizCreateState extends State<QuizCreate> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String question = "";
  String answer1 = "";
  String answer2 = "";
  late int rightAnswer;

  void _submit() {

    showDialog<void>(
      context: context,
      barrierDismissible: true, // user can tap anywhere to close the pop up
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Publish quiz?'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Question:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(question),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text("Answer:",
                        style: TextStyle(fontWeight: FontWeight.w700))),
                Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(answer1,
                      style: TextStyle(color:(rightAnswer == 0 ? Colors.green : Colors.black)),),
                    ),
                    const SizedBox(width: 30,),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(answer2,
                        style: TextStyle(color:(rightAnswer == 1 ? Colors.green : Colors.black)),),
                    ),
                  ],
                )
              ],
            ),
          ),
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
                      "quiz":[{
                        "question": question,
                        "answers": [
                          answer1,
                          answer2
                        ],
                        "correctAnswerIndex": rightAnswer
                    },],
                      "game":{
                        "players_joined": 0,
                        "current_question": 0,
                      }
                    });
                    Navigator.of(context).pop(); // Close the dialog
                    FocusScope.of(context)
                        .unfocus(); // Unfocus the last selected input field
                    _formKey.currentState?.reset();
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
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(Icons.account_circle, size: 32.0),
        //     tooltip: 'Profile',
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => MyProfilePage(),
        //           ));
        //     },
        //   ),
        //],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const Align(
                alignment: Alignment.topLeft,
                child: Text("First question",
                    style: TextStyle(
                      fontSize: 24,
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
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
                        setState(() {
                          question = value.capitalize();
                          // firstNameList.add(firstName);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          question = value.capitalize();
                        });
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
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Answer 1',
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
                        setState(() {
                          answer1 = value.capitalize();
                          // lastNameList.add(lastName);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          answer1 = value.capitalize();
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Answer 2',
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
                        setState(() {
                          answer2 = value;
                          // bodyTempList.add(bodyTemp);
                        });
                      },
                      onChanged: (value) {
                        setState(() {
                          answer2 = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField(
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder()),
                        items: const [
                          DropdownMenuItem(
                            value: 0,
                            child: Text("Answer 1"),
                          ),
                          DropdownMenuItem(
                            value: 1,
                            child: Text("Answer 2"),
                          )
                        ],
                        hint: const Text("Correct answer"),
                        onChanged: (value) {
                          setState(() {
                            rightAnswer = value!;
                            // measureList.add(measure);
                          });
                        },
                        onSaved: (value) {
                          setState(() {
                            rightAnswer = value!;
                          });
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(60)),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          _submit();
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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


extension StringExtension on String {
  // Method used for capitalizing the input from the form
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}