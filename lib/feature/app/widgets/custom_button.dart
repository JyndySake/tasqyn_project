import 'package:flutter/material.dart';
import 'package:project_app/core/resources/resources.dart';

class CustomButton extends StatelessWidget {
  final String titleButton;
  final void Function()? onTap;
  final Color? color;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? heightButton;
  final double? widthButton;

  const CustomButton({
    super.key,
    required this.titleButton,
    this.onTap,
    this.color,
    this.titleColor,
    this.heightButton,
    this.titleStyle,
    this.widthButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthButton ?? double.infinity,
      height: heightButton ?? 51,
      decoration: BoxDecoration(
        color: color ?? AppColors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titleButton, style: titleStyle ?? AppTextStyles.fs16w400),
            ],
          ),
        ),
      ),
    );
  }
}
