import 'package:kaloot/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';

void main() => runApp(
    MyApp()
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void dosmth(){

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill
                      )
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

                              child: TextField(
                                onEditingComplete: dosmth,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "a 6 digit pin",
                                    hintStyle: TextStyle(color: Colors.grey[400])
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
                            child: Text("Or"),
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
                        child: Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Placeholder()),
                                );
                              },
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(143, 148, 251, 1),),
                              ),
                              child: const Text("Create your own quiz!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                        ),
                      )),),
                      const SizedBox(height: 70,),
                      FadeAnimation(1.5, const Text("Want help?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}