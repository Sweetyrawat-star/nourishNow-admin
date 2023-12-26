import 'package:admin/shared/styles/colors.dart';
import 'package:flutter/material.dart';

import '../styles/dimension.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  final double height;
  final double fontSize;
final double fontHeight;
  const ExpandableTextWidget(
      {Key? key, required this.text, this.height = 0, this.fontSize=15,  this.fontHeight=1.5})
      : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;
  bool hiddenText = true;
  late double textHeight =
      widget.height == 0 ? Dimensions.height10 * 20 : widget.height;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: secondHalf.isEmpty
            ? Text(
                firstHalf,
                style: TextStyle(
                    fontSize: widget.fontSize,
                    height: widget.fontHeight,
                    color: AppColors.greyColor),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hiddenText ? "$firstHalf ..." : firstHalf + secondHalf,
                    style: TextStyle(
                        fontSize: widget.fontSize,
                        height: widget.fontHeight,
                        color: AppColors.greyColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        hiddenText = !hiddenText;
                      });
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hiddenText ? "Show more" : "Show less",
                          style: TextStyle(
                              fontSize: widget.fontSize+3,
                              height: 2,
                              color: AppColors.mainColor),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Icon(
                              hiddenText
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              color: AppColors.mainColor),
                        )
                      ],
                    ),
                  )
                ],
              ));
  }
}
