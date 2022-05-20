import 'package:flutter/services.dart';
import 'package:my_wallpapers/authentification/components/text_field_container.dart';
import 'package:email_validator/email_validator.dart';
import 'package:my_wallpapers/authentification/constants.dart';

import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedInputField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const RoundedInputField({
    Key? key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? "Enter valid email"
            : null,
        controller: widget.controller,
        textInputAction: TextInputAction.next,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
            icon: Icon(
              widget.icon,
              color: kPrimaryColor,
            ),
            hintText: widget.hintText,
            border: InputBorder.none),
      ),
    );
  }
}
