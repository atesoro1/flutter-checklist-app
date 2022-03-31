import 'package:flutter/material.dart';

class ListInstance extends StatelessWidget {
  ListInstance({Key? key, required this.name, required this.instanceId, this.instanceItems, required this.deadline}) : super(key: key);

  String name;
  int instanceId;
  Map<String, String>? instanceItems;
  DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
