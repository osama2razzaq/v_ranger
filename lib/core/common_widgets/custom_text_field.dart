import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v_ranger/core/values/values.dart';

class CustomTextField extends StatelessWidget {
  /// Custom TextField developed for bank rakyat project. This widget supports flex
  CustomTextField({
    this.labelText,
    this.isEnabled = true,
    this.hintText,
    this.onSubmit,
    this.autoFocus = false,
    this.textEditingController,
    this.focusNode,
    this.labelTextColor = AppColors.colorDark,
    this.backgroundColor = AppColors.colorWhite,
    this.validator,
    this.inputFormatters,
    this.maxLength,
    this.onChanged,
    this.disabledBorderColor,
    this.focusBorderColor,
    this.enabledBorderColor,
    this.keyboardType,
    this.hidePasswordIcon = true,
    this.textInputAction,
    this.hintStyle,
    this.inputStyle,

    /// Controls the suffixIcon visibility. When [isObscureEnabled] is set to true, suffixIcon will be visible. By default, it is false.
    this.isPassword = false,
    super.key,
    this.iconPath,
    this.iconPadding,
    this.iconBgColor = AppColors.primaryColor,
  });

  final String? Function(String? value)? validator;
  final Function(String value)? onChanged;
  final bool autoFocus;
  final Color? disabledBorderColor;
  final FocusNode? focusNode;
  final bool hidePasswordIcon;
  final String? hintText;
  final Color? iconBgColor;
  final String? iconPath;
  final List<TextInputFormatter>? inputFormatters;
  final bool isEnabled;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? labelText;
  final Color? labelTextColor;
  final Color? backgroundColor;
  final Color? focusBorderColor;
  final Color? enabledBorderColor;
  final int? maxLength;
  final ValueChanged? onSubmit;
  final TextEditingController? textEditingController;
  final TextInputAction? textInputAction;
  final TextStyle? hintStyle;
  final TextStyle? inputStyle;
  final EdgeInsetsGeometry? iconPadding;

  final ValueNotifier<bool> _passwordVisible = ValueNotifier<bool>(true);

  InputBorder _enabledBorder() {
    return OutlineInputBorder(
      gapPadding: AppValues.iconSize_28,
      borderSide: const BorderSide(
        color: AppColors.textColorDisable,
      ),
      borderRadius: BorderRadius.circular(AppValues.margin_30),
    );
  }

  InputBorder _errorBorder() {
    return OutlineInputBorder(
      gapPadding: AppValues.iconSize_28,
      borderSide: const BorderSide(
        color: AppColors.red600,
      ),
      borderRadius: BorderRadius.circular(AppValues.margin_30),
    );
  }

  InputBorder _focusedBorder() {
    return OutlineInputBorder(
      gapPadding: AppValues.iconSize_28,
      borderSide: BorderSide(
        color: focusBorderColor ?? AppColors.primaryColor,
      ),
      borderRadius: BorderRadius.circular(AppValues.margin_30),
    );
  }

  InputBorder _disabledBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: disabledBorderColor ?? AppColors.textColorDisable,
      ),
      borderRadius: BorderRadius.circular(AppValues.margin_30),
    );
  }

  // Widget _prefixWidget() {
  //   return Padding(
  //     padding: iconPadding ?? const EdgeInsets.symmetric(horizontal: AppValues.margin_10, vertical: AppValues.extraSmallPadding),
  //     child: CircleAvatar(
  //       radius: AppValues.radius_18,
  //       backgroundColor: iconBgColor,
  //       child: AssetImageView(fileName: iconPath!),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Container(
              margin: const EdgeInsets.only(left: 3),
              child: Text(labelText!,
                  style: PromptStyle.textfieldLabelStyle
                      .copyWith(color: labelTextColor))),
        if (labelText != null)
          const SizedBox(
            height: 6,
          ),
        ValueListenableBuilder<bool>(
          valueListenable: _passwordVisible,
          builder: (context, value, child) => TextFormField(
            cursorColor: AppColors.primaryColor,
            autofocus: autoFocus,
            controller: textEditingController,
            validator: validator,
            focusNode: focusNode,
            obscureText: isPassword ? _passwordVisible.value : false,
            style: inputStyle ?? PromptStyle.defaultStyle,
            textAlignVertical: TextAlignVertical.center,
            onChanged: onChanged,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction ?? TextInputAction.done,
            onFieldSubmitted: (text) {
              onSubmit?.call(text);
            },
            keyboardType: keyboardType,
            decoration: InputDecoration(
              enabled: isEnabled,
              filled: true,
              fillColor:
                  isEnabled ? backgroundColor : AppColors.textColorGreyLight,
              hintText: hintText,
              constraints: const BoxConstraints(maxHeight: AppValues.height_60),
              enabledBorder: _enabledBorder(),
              focusedBorder: _focusedBorder(),
              disabledBorder: _disabledBorder(),
              hintStyle: hintStyle ?? PromptStyle.textfieldHintStyle,
              errorBorder: _errorBorder(),
              focusedErrorBorder: _focusedBorder(),
              errorStyle: PromptStyle.textfieldErrorStyle,
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        value ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        _passwordVisible.value = !value;
                      },
                    )
                  : null,
              //  prefixIcon: iconPath != null ? _prefixWidget() : null,
              contentPadding: EdgeInsets.only(
                  left: iconPath != null
                      ? AppValues.padding_0
                      : AppValues.largePadding),
            ),
          ),
        ),
      ],
    );
  }
}
