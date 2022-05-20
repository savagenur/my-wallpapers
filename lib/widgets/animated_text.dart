import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
  mainAxisSize: MainAxisSize.min,
  children: <Widget>[
    const Text(
      'Be',
      style: TextStyle(),
    ),
    DefaultTextStyle(
      style: const TextStyle(
        fontFamily: 'Horizon',
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          RotateAnimatedText('AWESOME'),
          RotateAnimatedText('OPTIMISTIC'),
          RotateAnimatedText('DIFFERENT'),
        ],
        onTap: () {
          print("Tap Event");
        },
      ),
    ),
  ],
);
  }
}