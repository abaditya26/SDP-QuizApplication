import 'package:flutter/material.dart';

class ButtonLarge extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const ButtonLarge({Key? key, required this.text, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.blueGrey,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
