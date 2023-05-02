import 'package:firebase_database/firebase_database.dart';

class Question{

  String? questionText;
  List<Option> options = [];
  late final int? quizId;
  late final int? questionIndex;

  Question.create(this.quizId, this.questionIndex);

  Question({
    this.questionText,
    required this.options,
    this.quizId,
    this.questionIndex
  });

  /// Public factory
  static Future<Question> createAndPopulate(int quizId, int questionIndex) async {
    var question = Question.create(quizId, questionIndex);

    final ref = FirebaseDatabase.instance.ref("$quizId/quiz/$questionIndex");
    var snapshot = await ref.child("questionText").get();
    question.questionText = snapshot.exists ? snapshot.value as String : "no data for this field";

    // snapshot = await ref.child("correctAnswerIndex").get();
    // int correctQuestionIndex = snapshot.exists ? snapshot.value as int : 0;

    var snapshot1 = await ref.child("options").get();
    var ls = snapshot1.value as List;
    // TODO
    for(int i = 0; i<ls.length; i++){
      question.options.add(Option(
        optionIndex: ls[i]["optionIndex"],
        optionText: ls[i]["optionText"],
        isRight: ls[i]["isRight"],
      ));
    }
    // question.options = List<Option>.from(snapshot.value as List);
    // initialize options with index map the options texts
    // for(int i = 0; i<dboptionlist.length; i++){
    //   question.options?.add(Option(isRight: i == correctQuestionIndex, optionIndex: i, optionText: dboptionlist[i]));
    // }

    // Return the fully initialized object
    return question;

  }

  factory Question.fromJson(Map<String, dynamic> json) => Question(
      questionText: json["questionText"],
      options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      quizId: json["quizId"],
      questionIndex: json["questionIndex"],
  );

  Map<String, dynamic> toJson() => {
    "questionText": questionText,
    "quizId": quizId,
    "questionIndex": questionIndex,
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option{
  final int? optionIndex;
  String? optionText;
  bool? isRight;
  bool isSelected = false;

  /// Private constructor
  Option({this.optionIndex, this.optionText, this.isRight});

  factory Option.fromJson(Map<Object?, dynamic> json) => Option(
    optionIndex: json["optionIndex"],
    optionText: json["optionText"],
    isRight: json["isRight"],
  );

  Map<String, dynamic> toJson() => {
    "optionIndex": optionIndex,
    "optionText": optionText,
    "isRight": isRight,
  };

}
