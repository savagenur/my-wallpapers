import 'package:my_wallpapers/authentification/components/text_field_container.dart';
import 'package:my_wallpapers/authentification/constants.dart';

import 'package:flutter/material.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedPasswordField({
    Key? key,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<RoundedPasswordField> createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool isVisiblePass = false;

  

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          return value != null && value.length < 6
              ? "Enter minimum 6 characters"
              : null;
        },
        controller: widget.controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.done,
        obscureText: isVisiblePass ? false : true,
        decoration: InputDecoration(
            hintText: "Password",
            icon: Icon(
              Icons.lock,
              color: kPrimaryColor,
            ),
            suffixIcon: IconButton(
              splashRadius: 5,
              icon: Icon(
                isVisiblePass ? Icons.visibility_off : Icons.visibility,
                color: kPrimaryColor,
              ),
              onPressed: () => setState(() {
                isVisiblePass = !isVisiblePass;
              }),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
