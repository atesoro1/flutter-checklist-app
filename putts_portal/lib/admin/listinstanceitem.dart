import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class ListInstanceItem {
   ListInstanceItem({Key? key, required this.instanceItemId, required this.itemName, required this.itemType, required this.templateId, required this.completed, required this.instanceId});

  int? instanceItemId;
  String? itemName;
  String? itemType;
  String? content;
  ScanResult? scanResult;
  int? instanceId;
  int? templateId;
  bool? yesOrNo;
  int? completed;
  TextEditingController tc = new TextEditingController();
  TextEditingController issueMessageController = new TextEditingController();
}
