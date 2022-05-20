import 'package:flutter/material.dart';
import 'package:my_wallpapers/authentification/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function() press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        color: color,
      ),
      height: size.height / 16,
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
            onPressed: press,
            child: Text(
              text,
              style: TextStyle(color: textColor),
            )),
      ),
    );
  }
}
