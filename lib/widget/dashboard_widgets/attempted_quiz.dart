import 'package:flutter/material.dart';
import 'package:sdp_quiz_app/models/quiz_model.dart';
import 'package:sdp_quiz_app/widget/widgets.dart';

class AttemptedQuiz extends StatelessWidget {
  final List<QuizModel> quizzes;

  const AttemptedQuiz({Key? key, required this.quizzes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    final isDesktop = screenSize.width > 800;

    return Expanded(
      child: Container(
        margin: isDesktop
            ? EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isDesktop
              ? BorderRadius.all(Radius.circular(20.0))
              : BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
        ),
        child: ClipRRect(
          borderRadius: isDesktop
              ? BorderRadius.all(Radius.circular(20.0))
              : BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your Attempted Quiz",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ClipRRect(
                    borderRadius: isDesktop
                        ? BorderRadius.all(Radius.circular(20.0))
                        : BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0)),
                    child: GridView.builder(
                      itemCount: quizzes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).size.width > 1000
                            ? 3
                            : MediaQuery.of(context).size.width > 600
                                ? 2
                                : 1,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: (2 / 1),
                      ),
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        return QuizTile(
                          index: index,
                          quiz: quizzes[index],
                          isAttempted: true,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
