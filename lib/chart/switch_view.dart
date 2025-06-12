import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SwitchView extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  Function? selectItem;

  SwitchView({required this.leftTitle, required this.rightTitle});

  @override
  State<SwitchView> createState() => _SwitchViewState();
}

class _SwitchViewState extends State<SwitchView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            if (_currentIndex == 0) {
              return;
            }
            setState(() {
              _currentIndex = 0;
            });
            if (widget.selectItem != null) {
              widget.selectItem!(_currentIndex);
            }
          },
          child: Container(
            margin: EdgeInsets.only(left: 4),
            width: 120,
            height: 28,
            decoration: BoxDecoration(
                color: _currentIndex == 0
                    ? Constants.switchBtnHighBGColor
                    : Constants.actionBGColor,
                borderRadius: BorderRadius.circular(14)),
            child: Center(
              child: Constants.customTextWidget(widget.leftTitle, 14,
                  _currentIndex == 0 ? '#ffffff' : '#9C9C9C',
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        GestureDetector(
          onTap: () {
            if (_currentIndex == 1) {
              return;
            }
            setState(() {
              _currentIndex = 1;
            });
            if (widget.selectItem != null) {
              widget.selectItem!(_currentIndex);
            }
          },
          child: Container(
            width: 120,
            height: 28,
            decoration: BoxDecoration(
                color: _currentIndex == 1
                    ? Constants.switchBtnHighBGColor
                    : Constants.actionBGColor,
                borderRadius: BorderRadius.circular(14)),
            child: Center(
              child: Constants.customTextWidget(widget.rightTitle, 14,
                  _currentIndex == 1 ? '#ffffff' : '#9C9C9C',
                  fontWeight: FontWeight.w400),
            ),
          ),
        )
      ],
    );
  }

}
