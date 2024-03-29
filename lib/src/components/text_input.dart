import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vivo_vivo_police_app/src/utils/app_styles.dart';
import 'package:vivo_vivo_police_app/src/utils/app_validations.dart';

class TextInput extends StatefulWidget {
  // final Function(String value) onSearchChange;
  final TextEditingController inputController;
  final String label;
  final String hinText;
  final String textIsEmpty;
  final bool? obscureText;

  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final int? lenLimitTextInpFmt;
  final RegExp? validation;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final void Function()? onTap;
  final void Function(String value)? onTapSuffixIcon;
  final bool? readonly;
  final Key? inputKey;

  const TextInput(
      {super.key,
      // required this.onSearchChange,
      required this.hinText,
      required this.label,
      required this.textIsEmpty,
      required this.inputController,
      this.lenLimitTextInpFmt,
      this.obscureText = false,
      this.validation,
      this.textInputAction,
      this.keyboardType,
      this.textCapitalization = TextCapitalization.none,
      this.prefixIcon,
      this.suffixIcon,
      this.onTap,
      this.readonly,
      this.inputKey,
      this.onTapSuffixIcon});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    // final Size size = AppLayout.getSize(context);
    return TextFormField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(widget.lenLimitTextInpFmt),
        FilteringTextInputFormatter.allow((widget.validation != null)
            ? widget.validation!
            : Validations.exprOnlyLetter),
      ],
      key: widget.inputKey,
      controller: widget.inputController,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization!,
      readOnly: (widget.readonly) ?? false,
      obscureText: widget.obscureText!,
      onTap: widget.onTap,
      decoration: InputDecoration(
        hintText: widget.hinText,
        prefixIcon:
            (widget.prefixIcon) != null ? Icon(widget.prefixIcon) : null,
        suffixIcon: (widget.suffixIcon) != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.inputController.clear();
                  widget.onTapSuffixIcon!(widget.inputController.text);
                },
              )
            : null,
        label: Text(
          widget.label,
          style: Styles.textLabel,
        ),
      ),
      onSaved: (value) => {widget.inputController.text = value!},
      validator: (value) {
        if (value!.isEmpty) {
          return widget.textIsEmpty;
        }
        return null;
      },
    );
  }
}
