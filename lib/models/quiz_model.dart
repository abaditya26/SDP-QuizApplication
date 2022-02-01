class QuizModel {
  final String quizId;
  final String quizName;
  final String password;
  final bool isProtected;
  final String image;
  final String authorName;
  final String authorId;
  String docId;

  QuizModel(
      {required this.quizId,
      required this.quizName,
      required this.password,
      required this.isProtected,
      required this.image,
      required this.authorId,
      required this.authorName,
      required this.docId});
}
