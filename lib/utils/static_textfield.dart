
import 'package:flutter/material.dart';
import 'package:karamtechnology_services/appConstant/app_color.dart';

class StaticTextFormField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final String hintText;
  final Icon? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const StaticTextFormField({
    super.key,
    required this.textEditingController,
    this.hintText = '',
    this.validator,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        controller: textEditingController,
        textAlign: TextAlign.center,
        minLines: 1,
        maxLines: 1,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          suffixIcon: suffixIcon,
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: AppColor.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
