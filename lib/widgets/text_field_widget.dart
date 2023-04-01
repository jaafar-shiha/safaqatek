import 'package:flutter/material.dart';
import 'package:safaqtek/constants/app_colors.dart';
import 'package:safaqtek/constants/app_styles.dart';
import 'package:safaqtek/constants/text_field_type.dart';
import 'package:safaqtek/constants/validators.dart';

class TextFieldWidget extends StatefulWidget {
  final String labelText;
  final String? iconPath;
  final TextFieldType textFieldType;
  final bool obscureText;
  final Function(String) onChanged;
  final Widget? suffixIcon;
  final TextInputType textInputType;
  final String? initialValue;
  final bool isEnabled;
  final bool isValid;

  const TextFieldWidget({
    Key? key,
    required this.labelText,
     this.iconPath,
    required this.textFieldType,
    this.obscureText = false,
    this.isEnabled = true,
    required this.onChanged,
    this.suffixIcon,
    this.textInputType = TextInputType.text,
    this.initialValue = '',
    this.isValid = true,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late ValueNotifier<bool> isValidForm;

  TextEditingController controller = TextEditingController();
  late final bool isSuffixNull;

  @override
  void initState() {
    isValidForm = ValueNotifier(widget.initialValue != null ?true : false);
    isSuffixNull = widget.suffixIcon == null;
    controller = TextEditingController(text: widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isValid){
      isValidForm.value = false;
    }
    if (widget.initialValue != null && !widget.isEnabled){
      controller.text = widget.initialValue!;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: AppStyles.h2.copyWith(color: AppColors.gray),
          ),
          ValueListenableBuilder(
            valueListenable: isValidForm,
            builder: (context, val, child) {
              return TextFormField(
                controller: controller,
                keyboardType: widget.textInputType,
                enabled: widget.isEnabled,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: controller.text.isEmpty
                          ? AppColors.gray
                          : isValidForm.value
                              ? AppColors.darkMintGreen
                              : AppColors.ferrariRed,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: isValidForm.value ? AppColors.darkMintGreen : AppColors.ferrariRed,
                  )),
                  prefixIcon: widget.iconPath == null
                      ? null
                      : IconButton(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          icon: Image.asset(
                            widget.iconPath!,
                            width: 25,
                            height: 25,
                          ),
                          onPressed: null,
                        ),
                  suffixIcon: isSuffixNull ? null : widget.suffixIcon,
                  suffix: !isSuffixNull
                      ? null
                      : isValidForm.value
                          ? Icon(
                              Icons.check,
                              color: AppColors.darkMintGreen,
                            )
                          : Icon(
                              Icons.close_rounded,
                              color: AppColors.ferrariRed,
                            ),
                ),
                onChanged: (value) {
                  if (Validators.isValidForm(widget.textFieldType, value)) {
                    isValidForm.value = true;
                    widget.onChanged(value);
                  } else {
                    isValidForm.value = false;
                    widget.onChanged('');
                  }
                },
                style: AppStyles.textFieldLabel,
                obscureText: widget.obscureText,
              );
            },
          ),
        ],
      ),
    );
  }
}
