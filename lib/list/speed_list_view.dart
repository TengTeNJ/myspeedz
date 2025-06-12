import 'package:flutter/material.dart';
import 'package:my_speedz/list/speed_item_view.dart';
import 'package:my_speedz/models/speed_model.dart';

class SpeedListView extends StatefulWidget {
  List<SpeedModel> datas;


  SpeedListView({required this.datas});

  @override
  State<SpeedListView> createState() => _SpeedListViewState();
}

class _SpeedListViewState extends State<SpeedListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context ,index){
          return SpeedItemView(model: widget.datas[index],);
        }, separatorBuilder: (context ,index) => SizedBox(
      height: 16,
    ), itemCount: widget.datas.length);
  }
  }

