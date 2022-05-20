import 'package:my_wallpapers/authentification/constants.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.8,
      child: Row(
        children: [
          buildDivider(),
          SizedBox(width: 8,),
          Text("OR",
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600
          ),
          ), 
          SizedBox(width: 8,),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
          child: Divider(
            color: Color(0xFFD9D9D9),
            height: 1.5,
          ),
        );
  }
}