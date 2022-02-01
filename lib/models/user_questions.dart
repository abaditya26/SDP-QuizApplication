class UserQuestionsModel {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  String selected;
  final String docId;

  UserQuestionsModel(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4,
      required this.answer,
      required this.selected,
      required this.docId});
}
