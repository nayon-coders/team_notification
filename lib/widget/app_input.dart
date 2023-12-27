import 'package:flutter/material.dart';
import 'package:userapp/utilitys/app_color.dart';

class AppInput extends StatelessWidget {
  const AppInput({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyBoardType = TextInputType.text,
    this.maxLine = 1,
    this.onClick,
    this.obscureText = false,
    this.oneChange,
    this.suffixIcon,
    this.redOnly = false
  });

  final String title;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? Function(String?)? oneChange;
  final TextInputType keyBoardType;
  final int maxLine;
  final VoidCallback? onClick;
  final bool obscureText;
  final bool redOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:  [
        Text(title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.black
          ),
        ),
        SizedBox(height: 10,),
        TextFormField(
          readOnly: redOnly,
          onTap: onClick,
          maxLines: maxLine,
          keyboardType: keyBoardType,
          controller: controller,
          onChanged: oneChange,
          obscureText: obscureText,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(10),
              hintText: hintText,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade200)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: Colors.grey.shade400)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(width: 1, color: AppColor.mainColor)
              )
          ),
          validator: validator,
        )
      ],
    );
  }
}
