import 'package:admin/shared/styles/colors.dart';
import 'package:admin/shared/styles/dimension.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color fontColor;
  final String? buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double? radius;
  final IconData? icon;
  final Color? filledColor;
  final bool? center;
  const CustomButton(
      {Key? key,
        this.center=true,
      this.filledColor,
      required this.onPressed,
      this.buttonText,
      this.transparent = false,
      this.margin,
      this.height,
      this.width,
      this.fontColor = Colors.white,
      this.fontSize,
      this.radius = 30,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatStyle = TextButton.styleFrom(
        backgroundColor: filledColor ??
            (transparent == true ? Colors.white : AppColors.mainColor),
        minimumSize: Size(width != null ? width! : Dimensions.screenWidth,
            height != null ? height! : Dimensions.height10 * 5.6),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            side: transparent == false
                ? BorderSide.none
                : BorderSide(width: 1, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(radius!)));
    return Container(
      alignment: center==true? Alignment.center:Alignment.topLeft,
      margin: margin??EdgeInsets.zero,
      child: SizedBox(
        width: width ?? Dimensions.screenWidth,
        height: height ?? Dimensions.height10 * 5.6,
        child: TextButton(
          onPressed: onPressed,
          style: flatStyle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: Dimensions.width10 * 2),
                      child: Icon(
                        icon,
                        color: Colors.white,
                      ),
                    )
                  : const SizedBox(),
              buttonText!=null?Text(
                buttonText!,
                style: TextStyle(
                  fontSize: fontSize ?? Dimensions.height10 * 1.6,
                  color: transparent==true?AppColors.mainColor:fontColor,
                ),
              ):const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
