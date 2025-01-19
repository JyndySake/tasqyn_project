import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_app/core/resources/resources.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatelessWidget {
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController? controller;
  final bool? autofocus;
  final String? hintText;
  final bool? obscureText;
  final String? prefixIcon;
  final Color? fillColor;
  final bool? filled;
  final Widget? suffixIcon;
  final Color? hintStyleColor;
  final BorderSide? enabledBorderSide;
  final BorderSide? focusedBorderSide;
  final BorderSide? errorBorderSide;
  final BorderSide? focusedErrorBorder;
  final bool? readOnly;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onTapPrefixIcon;
  final Function()? onEditingComplete;
  final TextAlignVertical? textAlignVertical;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final int? maxLines;
  final double? hintStyleSize;
  final Widget? label;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final bool? alignLabelWithHint;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextStyle? errorStyle;
  final int? maxLength;
  final String? counterText;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.obscureText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintStyleColor,
    this.filled,
    this.fillColor,
    this.enabledBorderSide,
    this.focusedBorderSide,
    this.readOnly,
    this.onTap,
    this.onChanged,
    this.textAlignVertical,
    this.padding,
    this.keyboardType,
    this.maxLines,
    this.hintStyleSize,
    this.label,
    this.inputFormatter,
    this.autofocus,
    this.floatingLabelAlignment,
    this.alignLabelWithHint,
    this.validator,
    this.errorBorderSide,
    this.focusedErrorBorder,
    this.focusNode,
    this.errorStyle,
    this.onFieldSubmitted,
    this.maxLength,
    this.counterText,
    this.onEditingComplete,
    this.onTapPrefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: onEditingComplete,
      maxLength: maxLength,
      inputFormatters: inputFormatter,
      keyboardType: keyboardType,
      autofocus: autofocus ?? false,
      focusNode: focusNode,
      maxLines: maxLines ?? 1,
      readOnly: readOnly ?? false,
      obscureText: obscureText ?? false,
      controller: controller,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      textAlignVertical: textAlignVertical,
      decoration: InputDecoration(
        counterText: counterText,
        floatingLabelAlignment: floatingLabelAlignment,
        alignLabelWithHint: alignLabelWithHint,
        contentPadding: padding ?? const EdgeInsets.only(left: 16, top: 15, bottom: 15, right: 16),
        prefixIcon: prefixIcon != null
            ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: GestureDetector(onTap: onTapPrefixIcon, child: SvgPicture.asset('$prefixIcon')),
              )
            : null,
        suffixIcon: suffixIcon,
        label: label,
        labelStyle: AppTextStyles.fs16w400,
        hintText: hintText,
        hintStyle: AppTextStyles.fs16w400.copyWith(
          color: hintStyleColor,
          fontSize: hintStyleSize ?? 16,
        ),
        focusedBorder: OutlineInputBorder(
          // borderSide: focusedBorderSide ?? BorderSide(),
          // borderSide: focusedBorderSide ??
          //     const BorderSide(
          //       color: AppColors.primaryBlue,
          //     ),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          // borderSide: enabledBorderSide ?? BorderSide(),
          // borderSide: enabledBorderSide ?? const BorderSide(color: AppColors.lightStroke1),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          // borderSide: errorBorderSide ??
          //     const BorderSide(
          //       color: AppColors.additionalRed,
          //     ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          // borderSide: focusedErrorBorder ??
          //     const BorderSide(
          //       color: AppColors.additionalRed,
          //     ),
          borderRadius: BorderRadius.circular(12),
        ),
        // errorText: null,
        errorStyle: errorStyle ?? const TextStyle(height: 0),
        fillColor: fillColor ?? AppColors.white2,
        filled: true,
      ),
      validator: validator,
    );
  }
}
