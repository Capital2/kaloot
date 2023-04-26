import 'package:kaloot/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:kaloot/quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:kaloot/quiz_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(143, 148, 251, .8)
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(1, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-1.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.3, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/light-2.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(1.5, Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/clock.png')
                              )
                          ),
                        )),
                      ),
                      Positioned(
                        child: FadeAnimation(1.6, Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text("Kaloot", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(1.8, Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            const Center(
                              child: Text("Enter a quiz pin"),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),

                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length < 6) {
                                      return 'Please provide a 6 digit pin';
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  controller: myController,
                                  onEditingComplete: () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => QuizGame(quizId: (int.parse(myController.text)))),
                                    );
                                    }
                                  },
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "a 6 digit pin",
                                      hintStyle: TextStyle(color: Colors.grey[400])
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 30,),
                      FadeAnimation(2, Container(
                          height: 30,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     gradient: const LinearGradient(
                          //         colors: [
                          //           Color.fromRGBO(143, 148, 251, 1),
                          //           Color.fromRGBO(143, 148, 251, .6),
                          //         ]
                          //     )
                          // ),
                          child: const Center(
                            child: Text("Or",
                              style: TextStyle(fontSize: 25),),
                          ),),),
                      const SizedBox(height: 30,),
                      FadeAnimation(2, Container(
                        height: 50,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     gradient: const LinearGradient(
                        //         colors: [
                        //           Color.fromRGBO(143, 148, 251, 1),
                        //           Color.fromRGBO(143, 148, 251, .6),
                        //         ]
                        //     )
                        // ),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TestWidget()),
                              );
                            },
                            style: const ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(143, 148, 251, 1),),
                            ),
                            child: const Text("Create your own quiz!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),),

                        )),),
                      const SizedBox(height: 70,),
                      const FadeAnimation(1.5, Text("Want help?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
                    ],
                  ),
                )
              ],
            ),
          )
    );
  }
}

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizCreate();
  }

}