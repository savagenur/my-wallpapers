import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrevAndNext extends StatefulWidget {
  final int page;
  final void Function() next;
  final void Function() prev;

  const PrevAndNext({Key? key, required this.page,required this.next,required this.prev})
      : super(key: key);

  @override
  State<PrevAndNext> createState() => _PrevAndNextState();
}

class _PrevAndNextState extends State<PrevAndNext> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.02,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.page > 1
              ? TextButton(
                  onPressed: widget.prev,
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  child: Transform.rotate(
                      angle: 180 * pi / 180,
                      child: Lottie.asset(
                        "assets/animated/next.json",
                        height: 150,
                      )),
                )
              : Container(),
          TextButton(
              onPressed: widget.next,
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100))),
              child: Lottie.asset("assets/animated/next.json", height: 150))
        ],
      ),
    );
  }
}
