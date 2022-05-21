import 'package:flutter/material.dart';
import 'package:my_wallpapers/authentification/constants.dart';

class InfoWidget extends StatelessWidget {
  final String title;
  final String text;

  const InfoWidget({Key? key, required this.title, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor),
        borderRadius: BorderRadius.circular(20)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              SizedBox(height: 5,),
              
              Container(
                width: 200,
                child:text.isEmpty?Text("None"): Text(text, overflow: TextOverflow.ellipsis,)),
            ],
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text("EDIT", style: TextStyle(color: Colors.white),),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20)
            ),
          )
        ],
      ),
    );
  }
}
