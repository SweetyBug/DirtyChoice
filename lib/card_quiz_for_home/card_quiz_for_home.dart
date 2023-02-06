import 'package:flutter/material.dart';
import '../quiz/quiz_models/quiz_model.dart';


class CardQuizForHome extends StatelessWidget {
  const CardQuizForHome({Key? key, required this.quizModel}) : super(key: key);
  final QuizModel quizModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home()));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Image.asset("images/picture.png"),
                  )),
              const SizedBox(height: 10),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(quizModel.description, textAlign: TextAlign.center,),
                    ],
                  )),
              // Text(
              //     '${List.generate(quizModel.questions.length,
              //             (questionsIndex) => quizModel.
              //         questions[questionsIndex].title)}'),
            ],
          ),
        ),
      ),
    );
  }
}
