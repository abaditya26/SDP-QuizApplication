class QuestionsModel {
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  final String answer;
  final String docId;

  QuestionsModel(
      {required this.question,
      required this.option1,
      required this.option2,
      required this.option3,
      required this.option4,
      required this.answer,
      required this.docId});
}
