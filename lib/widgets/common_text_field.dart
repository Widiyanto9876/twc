import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable

class CommonInputFieldWithLabel extends StatefulWidget {
  final String? label;
  final String subLabel;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? errorText;
  final Function(String)? onChanged;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Function(String? value)? onSaved;
  final bool? obscureText;
  final InputDecoration? decoration;
  final Color? cursorColor;
  final FormFieldValidator<String>? validator;
  final bool isEnable;
  final bool isOptionalForm;
  final int maxLines;
  final Widget? suffixIcon;
  final Widget? prefixWidget;
  final Color? fillColor;
  final String? counter;
  final String? prefixText;
  final bool isUsingScrollbar;
  final bool isUsingLabel;
  final bool isPhoneNumberValid;
  final TextStyle? customTextStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String? helperText;
  final TextStyle? helperStyle;
  final Widget? prefixLabel;
  final bool isReadOnly;

  const CommonInputFieldWithLabel({
    super.key,
    this.label,
    required this.hint,
    this.subLabel = "",
    this.controller,
    this.keyboardType,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.textInputAction,
    this.onEditingComplete,
    this.onTap,
    this.onSaved,
    this.obscureText,
    this.decoration,
    this.cursorColor,
    this.validator,
    this.isEnable = true,
    this.isOptionalForm = false,
    this.maxLines = 1,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.prefixWidget,
    this.counter,
    this.prefixText,
    this.isUsingScrollbar = false,
    this.isUsingLabel = true,
    this.isPhoneNumberValid = true,
    this.customTextStyle,
    this.hintStyle,
    this.errorStyle,
    this.inputFormatters,
    this.helperText,
    this.helperStyle,
    this.prefixLabel,
    this.isReadOnly = false,
  });

  @override
  AutovalidationTextFieldState createState() => AutovalidationTextFieldState();
}

class AutovalidationTextFieldState extends State<CommonInputFieldWithLabel> {
  late TextEditingController _controller;
  bool _isError = false;
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 50,
    keepScrollOffset: false,
  );

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isUsingLabel)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (widget.label?.isNotEmpty ?? false)
                      ? _buildLabel()
                      : const SizedBox.shrink(),
                  widget.prefixLabel ?? const SizedBox.shrink(),
                ],
              ),
              _buildSubTitle(),
              SizedBox(height: 10.h),
            ],
          ),
        _inputFieldSection(),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          widget.label ?? "",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTitle() {
    if (widget.subLabel.isNotEmpty) {
      return Text(
        widget.subLabel,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _inputFieldSection() {
    return TextFormField(
      readOnly: widget.isReadOnly,
      enabled: widget.isEnable,
      maxLines: widget.maxLines,
      controller: _controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLength: widget.maxLength,
      obscureText: widget.obscureText ?? false,
      style: widget.customTextStyle,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onTap: widget.onTap,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onSaved: widget.onSaved,
      validator: (value) {
        setState(() {
          if (widget.isOptionalForm) {
            if (value?.isNotEmpty ?? false) {
              _isError =
                  widget.validator != null && widget.validator!(value) != null;
            } else {
              _isError = false;
            }
          } else {
            _isError =
                widget.validator != null && widget.validator!(value) != null;
          }
        });
        return _isError ? widget.errorText : null;
      },
      cursorColor: widget.cursorColor,
      decoration: InputDecoration(
        counterText: widget.counter,
        prefixIcon: widget.prefixWidget,
        prefixText: widget.prefixText,
        isDense: true,
        filled: true,
        fillColor: widget.fillColor,
        suffixIcon: widget.suffixIcon,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        hintText: widget.hint,
        errorText: widget.isPhoneNumberValid
            ? (_isError ? widget.errorText : null)
            : widget.errorText,
        hintStyle: widget.hintStyle,
        helperText: widget.helperText,
        helperStyle: widget.helperStyle,
      ),
    );
  }
}
