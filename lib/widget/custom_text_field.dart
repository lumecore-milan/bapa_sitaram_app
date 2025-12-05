import 'package:bapa_sitaram/constants/app_colors.dart';
import 'package:bapa_sitaram/utils/font_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../extensions/size_box_extension.dart';


final class CustomDropDownItem {
  CustomDropDownItem({required this.title});

  final String title;
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    required this.controller,
    required this.validator,
    required this.label,
    required this.hint,
    required this.errorMessage,
    this.enabled = true,
    this.isMobile = false,
    this.readOnly = false,
    super.key,
    this.formatter,
    this.textFontSize = 0,
    this.hintFontSize = 0,
    this.labelFontSize = 0,
    this.inputType = TextInputType.name,
    this.isPassword = false,
    this.isFilled = false,
    this.required = true,
    this.prefix,
    this.suffix,
    this.prefixMaxWidth,
    this.onChanged,
    this.onTap,
    this.maxLines,
    this.fillColor,
    this.showMainTitle = true,
    this.greyBorder = true,
    this.removeBorder = false,
    this.isDropDown = false,
    this.autoValidateMode,
    this.dropDownItems=const [],
    this.selectedItem,
  });

  final bool removeBorder;
  final int? maxLines;
  final int textFontSize;
  final int hintFontSize;
  final int labelFontSize;
  final List<TextInputFormatter>? formatter;
  final TextInputType inputType;
  final TextEditingController controller;
  final bool enabled, readOnly, isPassword;
  final String label, hint, errorMessage;
  final bool isFilled, required;
  final Widget? prefix, suffix;
  final int? prefixMaxWidth;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final bool isMobile;
  final bool showMainTitle;
  final bool greyBorder;
  final Color? fillColor;
  final bool isDropDown;
  final String? Function(String?)? validator;
  final AutovalidateMode? autoValidateMode;
  final List<String> dropDownItems;
  final String? selectedItem;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.showMainTitle)
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.label.replaceAll('*', ' '),
                  style: bolder(fontSize: 14, color: CustomColors().black1000),
                ),
                if(widget.required==true)
                TextSpan(
                  text: '*',
                  style: bolder(fontSize: 14, color: CustomColors().red500),
                ),
              ],
            ),
            softWrap: true,
          ),
        if (widget.showMainTitle) 10.h,
        widget.isDropDown
            ? _getDropDown()
            : TextFormField(
                cursorColor: CustomColors().primaryColorDark,
                maxLines: widget.maxLines ?? 1,
                onChanged: widget.onChanged,

                onTap: widget.onTap,
                style: semiBold(color: CustomColors().black, fontSize: 14),
                controller: widget.controller,
                autovalidateMode: widget.autoValidateMode??AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.next,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                inputFormatters: widget.formatter,
                obscureText: widget.isPassword,
                keyboardType: widget.inputType,
                obscuringCharacter: '*',
                decoration: getDecoration(),
                validator:widget.validator,


        /*  (newVal) {
                  if (widget.required) {
                    if (widget.isMobile && (newVal ?? '').length != 10) {
                      return widget.errorMessage;
                    }else if(widget.is)
                    if ((newVal ?? '').isEmpty) {
                      return widget.errorMessage;
                    }
                  } else {
                    return null;
                  }
                  return null;
                },*/
              ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _getDropDown() {
    return DropdownButtonFormField<String>(
      initialValue:widget.selectedItem,
      isExpanded: true,
      menuMaxHeight: 350,
      validator: (t){
        if (widget.required) {
          if (t==null) {
            return widget.errorMessage;
          }
        } else {
          return null;
        }
        return null;
      },
      alignment: AlignmentDirectional.centerStart,
      decoration: getDecoration(),
      dropdownColor: CustomColors().pink50,
      items: widget.dropDownItems.map((type) {
        return DropdownMenuItem<String>(
            value: type,
            child: Text(type));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          widget.onChanged!(value);
        }
      },
    );
  }

  InputDecoration getDecoration() {
    final InputBorder errorBorder = widget.removeBorder
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: CustomColors().primaryColorDark,
              width: 1,
            ),
          );
    final InputBorder normalBorder = widget.removeBorder
        ? InputBorder.none
        : OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: widget.greyBorder
                  ? CustomColors().grey600
                  : CustomColors().primaryColorDark,
              width: 1,
            ),
          );
    final decoration = InputDecoration(
      prefixIcon: widget.prefix,
      suffixIcon: widget.suffix,
      hintText: widget.hint,
      isDense: widget.removeBorder == true,
      contentPadding: widget.removeBorder
          ? EdgeInsets.only(top: 10)
          : EdgeInsets.all(10),
      fillColor: widget.fillColor ?? CustomColors().layoutPrimaryBackground,
      filled: widget.isFilled,
      labelStyle: semiBold(
        fontSize: 14,
        color: CustomColors().primaryColorDark,
      ),
      errorStyle: semiBold(
        fontSize: 10,
        color: CustomColors().primaryColorDark,
      ),
      hintStyle: semiBold(fontSize: 12, color: CustomColors().grey600),
      border: normalBorder,
      errorBorder: errorBorder,
      focusedBorder: normalBorder,
      disabledBorder: normalBorder,
      enabledBorder: normalBorder,
      focusedErrorBorder: errorBorder,
      prefixIconConstraints: BoxConstraints(
        maxWidth: widget.prefixMaxWidth != null
            ? widget.prefixMaxWidth!.toDouble()
            : 24,
        minWidth: 0,
      ),
      suffixIconConstraints: BoxConstraints(
        maxWidth: widget.prefixMaxWidth != null
            ? widget.prefixMaxWidth!.toDouble()
            : 24,
        minWidth: 0,
      ),
    );
    return decoration;
  }
}
