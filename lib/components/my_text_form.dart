import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../size_config.dart';


class MyTextForm extends StatelessWidget {
  const MyTextForm({Key? key,this.inputFormatters,this.maxLines=1,this.onTap, this.readOnly=false,this.controller,this.obscureText=false,required this.icon, this.keyboardType,required this.label, required this.hint, this.validator, this.onChanged, this.onSaved}) : super(key: key);
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final bool readOnly;
  final void Function()? onTap;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      maxLines: maxLines,
      readOnly: readOnly,
      controller: controller,
      obscureText:obscureText,
      keyboardType: keyboardType,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      inputFormatters:inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorStyle: const TextStyle(height: 0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              getProportionateScreenWidth(20),
              getProportionateScreenWidth(20),
              getProportionateScreenWidth(20),
            ),
            child: Icon(icon,size: getProportionateScreenWidth(22),)),
      ),
    );
  }
}
