import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home/home.dart';
import 'quiz_models/quiz_model.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  List<QuizModel> quizes = [];
  bool loading = true;

  getQuiz() async {
    CollectionReference quizList =
        FirebaseFirestore.instance.collection('quiz');
    var snapshot = await quizList.get();
    var list = snapshot.docs;
    for (var element in list) {
      quizes.add(QuizModel.fromJson(element));
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    print('init');
    getQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('loading $loading');
    return Scaffold(
      backgroundColor: Colors.white,
      body: !loading
          ? ListView.separated(
              itemBuilder: (context, index) => InkWell(
                // onTap: () {
                //   Navigator.push(
                //       context, MaterialPageRoute(builder: (context) => Home()));
                // },
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(quizes[index].title),
                        Text(quizes[index].description),
                        Text(
                            '${List.generate(quizes[index].questions.length,
                                    (questionsIndex) => quizes[index].
                                    questions[questionsIndex].title)}'),
                      ],
                    ),
                  ),
                ),
              ),
              separatorBuilder: (_, __) => const SizedBox(
                height: 10,
              ),
              itemCount: quizes.length,
            )
          : const Center(
              child: Text(
                'Quiz loading',
                style: TextStyle(color: Colors.black54),
              ),
            ),
    );
  }
}
