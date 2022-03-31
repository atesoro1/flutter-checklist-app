import 'package:flutter/cupertino.dart';

class Assignment {

  Assignment({required this.assignmentId, required this.firstName, required this.lastName, required this.description, required this.completed, required this.comments, required this.timeCompleted});

  int? assignmentId;
  String? firstName;
  String? lastName;
  String? description;
  int? completed;
  String? comments;
  DateTime? timeCompleted;
}