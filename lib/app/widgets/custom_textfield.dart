import 'package:earnly/app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CustomTextField extends StatelessWidget {
  TextEditingController? controller;
  int? maxLines;
  int? minLines;
  FocusNode? focusNode;
  String? hintText;
  TextStyle? hintStyle;
  TextStyle? textStyle;
  IconData? prefixIcon;
  Color? prefixIconColor;
  IconData? suffixIcon;
  VoidCallback? onSuffixTap;
  bool? isObscure;
  Color? bgColor;
  Color? enabledBorderColor;
  String? Function(String?)? validator;
  double? fieldHeight;
  Function(String)? onChanged;
  Function()? onEditingComplete;
  bool? readOnly;
  TextInputType? keyboardType;
  int? maxLength;
  String? errorText;
  InputBorder? focusedBorder;
  InputBorder? enabledBorder;
  Function()? onTap;
  Widget? prefix;
  List<TextInputFormatter>? inputFormatters;
  EdgeInsetsGeometry? contentPadding;
  String? label;
  TextStyle? labelStyle;
  FloatingLabelBehavior? floatingLabelBehavior;
  Color? suffixIconcolor;

  CustomTextField({
    super.key,
    this.hintStyle,
    this.floatingLabelBehavior,
    this.label,
    this.labelStyle,
    this.prefix,
    this.maxLines,
    this.minLines,
    this.focusedBorder,
    this.enabledBorder,
    this.onChanged,
    this.errorText,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.bgColor,
    this.enabledBorderColor,
    this.onSuffixTap,
    this.isObscure,
    this.hintText,
    this.fieldHeight,
    this.validator,
    this.readOnly,
    this.onEditingComplete,
    this.keyboardType,
    this.maxLength,
    this.textStyle,
    this.onTap,
    this.prefixIconColor,
    this.focusNode,
    this.inputFormatters,
    this.contentPadding,
    this.suffixIconcolor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        maxLength: maxLength,
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        validator:
            validator ??
            (value) {
              if (value!.isEmpty) {
                return "";
              } else if (errorText?.isNotEmpty == true) {
                return "";
              }
              return null;
            },
        onTap: onTap,
        onChanged: onChanged,
        readOnly: readOnly ?? false,
        onEditingComplete: onEditingComplete,
        obscureText: isObscure ?? false,
        cursorColor: AppColors.primaryColor,
        controller: controller,
        keyboardType: keyboardType,
        style:
            textStyle ??
            GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
        maxLines: maxLines ?? 1,
        minLines: minLines ?? 1,
        decoration: InputDecoration(
          fillColor: bgColor ?? Colors.grey.shade50,
          errorText: null,
          errorStyle: const TextStyle(height: 0, fontSize: 0),
          errorMaxLines: null,
          error: null,
          filled: bgColor != null ? true : false,
          counterText: maxLength != null ? "" : null,
          hintText: hintText,
          hintStyle:
              hintStyle ??
              GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
          label: label != null ? Text(label!) : null,
          labelStyle:
              labelStyle ??
              GoogleFonts.poppins(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
          floatingLabelBehavior: floatingLabelBehavior,
          prefix: prefix,
          prefixIcon:
              prefixIcon == null
                  ? null
                  : Icon(
                    prefixIcon,
                    color: prefixIconColor ?? const Color(0xff36534F),
                  ),
          suffixIcon: IconButton(
            onPressed: onSuffixTap,
            icon: Icon(
              suffixIcon,
              size: 20,
              color:
                  suffixIconcolor ?? const Color.fromARGB(255, 207, 207, 207),
            ),
          ),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  width: 1,
                  color: enabledBorderColor ?? Colors.grey,
                ),
              ),
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(width: 1, color: AppColors.primaryColor),
              ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(9),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
