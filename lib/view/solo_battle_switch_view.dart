import 'package:flutter/material.dart';

import '../constants/constants.dart';

class SoloBattleSwitchView extends StatefulWidget {
  String leftTitle;
  String rightTitle;
  Function? selectItem;

  SoloBattleSwitchView({required this.leftTitle, required this.rightTitle});

  @override
  State<SoloBattleSwitchView> createState() => _SoloBattleSwitchViewState();
}

class _SoloBattleSwitchViewState extends State<SoloBattleSwitchView> {
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
            width: 63,
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
            width: 63,
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
