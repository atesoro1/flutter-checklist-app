import 'package:flutter/material.dart';

class ListTemplate extends StatelessWidget {
  ListTemplate({Key? key, required this.name, required this.departmentName, required this.templateItems}) : super(key: key);

  String name;
  String departmentName;
  Map<String, String> templateItems;
  bool templateSelected = false;
  int timeToFinish = 30;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
