class QuizModel {
  QuizModel({
    required this.title,
    required this.description,
    required this.questions,
  });

  final String title;
  final String description;
  final List<QuestionModel> questions;

  factory QuizModel.fromJson(json) {
    return QuizModel(
        title: json['title'],
        description: json['description'],
        questions: questionsFromJson(json['questions']));
  }

  static List<QuestionModel> questionsFromJson(List json) {
    List<QuestionModel> questions = [];
    for (var element in json) {
      questions.add(QuestionModel.fromJson(element));
    }
    return questions;
  }
}

class QuestionModel {
  QuestionModel({required this.title, required this.answers});

  final String title;
  final List<AnswerModel> answers;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        title: json['title'], answers: answersFromJson(json['answers']));
  }

  static List<AnswerModel> answersFromJson(List json) {
    List<AnswerModel> answers = [];
    for (var element in json) {
      answers.add(AnswerModel.fromJson(element));
    }
    return answers;
  }
}

class AnswerModel {
  AnswerModel({required this.title, required this.isRight});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(title: json['title'], isRight: json['is_right']);
  }

  final String title;
  final bool isRight;
}
