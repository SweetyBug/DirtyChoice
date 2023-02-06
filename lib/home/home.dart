import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dirtychoice/quiz/quiz_models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../card_quiz_for_home/card_quiz_for_home.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final List<Map> myProducts =
    List.generate(6, (index) => {"id": index, "name": "Product $index"})
        .toList();

class _HomeState extends State<Home> {
  List<QuizModel> quizes = [];
  bool loading = true;

  // Future<String> getPhotoByQuery(String query) async {
  //   Map<String, String> headers = {
  //     "Accept-Version": "v1",
  //     "Authorization": "Client-ID Nv6KuhzBCEplLAM4MgYLLzs0rK3tG3v93TgnhQQGCwo"
  //   };
  //   var resp = await get(
  //       Uri.parse('https://api.unsplash.com/search/photos?query=title'),
  //       headers: headers);
  //   if (resp.statusCode == 200) {
  //     var json = jsonDecode(resp.body);
  //     var imgURL = json["results"][0]["urls"]["small"];
  //     return imgURL;
  //   }
  //   return "";
  // }

  getQuiz() async {
    CollectionReference quizList =
        FirebaseFirestore.instance.collection('quiz');
    var snapshot = await quizList.get();
    var list = snapshot.docs;
    for (var element in list) {
      quizes.add(QuizModel.fromJson(element));
    }
    // for (var element in quizes) {
    //   var imgURL = await getPhotoByQuery(element.title);
    //   print(imgURL);
    // }
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    print('init');
    getQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loading
          ? ListView(
              physics: const ScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 50, right: 39, left: 39, bottom: 35),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: AlignmentDirectional.bottomCenter,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.all(Radius.circular(15.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                              offset: Offset(0, 4), // Shadow position
                            ),
                          ],
                        ),
                        height: 125,
                        child: const Text(
                          "Dirty Choice",
                          style: TextStyle(
                            fontSize: 55,
                            fontFamily: "Lato",
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 159,
                        child: Image.asset(
                          'images/app_bar_pgoto.png',
                          fit: BoxFit.cover,
                          width: 155,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: GridView.builder(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 2 / 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: 2),
                      itemCount: myProducts.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return CardQuizForHome(
                          quizModel: quizes[index],
                        );
                      }),
                )
              ],
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
