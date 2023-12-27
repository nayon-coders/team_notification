import 'package:flutter/material.dart';
import 'package:userapp/utilitys/app_color.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onClick,
    required this.text,
    this.bg = AppColor.mainColor,
    this.borderColor = AppColor.mainColor,
    this.textColor = AppColor.white,
    this.margin,
    this.isLoading = false
  });

  final VoidCallback onClick;
  final String text;
  final Color bg;
  final Color borderColor;
  final Color textColor;
  final bool isLoading;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: double.infinity,
        margin: margin,
        height: 60,
        decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(width: 1, color: borderColor)
        ),
        child: Center(
          child: isLoading ? CircularProgressIndicator(color: Colors.white,) : Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: textColor,
                fontSize: 20
            ),
          ),
        ),
      ),
    );
  }
}
