import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class CustomElevatedButton extends StatefulWidget {

  CustomElevatedButton({Key? key, required this.nameTypeBarcodeTriggerIdList, required this.name, required this.type, this.onPressed, required this.col}) : super(key: key);

  final String? name;
  Object? type;
  VoidCallback? onPressed;
  final int col;
  List<Map> nameTypeBarcodeTriggerIdList;

  @override
  _CustomElevatedButtonState createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  String? chosenType;

  @override
  Widget build(BuildContext context) {

    return Container(
      height: ResponsiveValue(context, defaultValue: 70.0, valueWhen: [Condition.smallerThan(name: TABLET, value: 175.0)]).value!,
      child: ElevatedButton(
        clipBehavior: Clip.none,
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(70, 70)),
            side: BorderSide(color: Colors.white)
          )
        ),
        onPressed: widget.onPressed,
        child: ResponsiveRowColumn(
          layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.ROW, valueWhen: [Condition.smallerThan(name: TABLET, value: ResponsiveRowColumnType.COLUMN)]).value!,
          children: [
            ResponsiveRowColumnItem(child: Expanded(child: Container(child: Icon(Icons.delete)))),
            ResponsiveRowColumnItem(child: Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  widget.name!,
                  softWrap: true,
                ),
              ),
            ),),
            ResponsiveRowColumnItem(child: Expanded(
              flex: 2,
              child: Container(
                child: Text('${widget.type == 'longResponse' ? 'Long Response' : (widget.type == 'shortResponse' ? 'Short Response' : widget.type)}'),
              ),
            ),),
            ResponsiveRowColumnItem(child: Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(10),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(360)),
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.keyboard_control,
                        color: Colors.black,
                      ),
                    ),
                    items: <String>[
                      'yes/no',
                      'shortResponse',
                      'longResponse',
                      'barcode',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String> (
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        widget.type = value;
                        for(var x = 0; x < widget.nameTypeBarcodeTriggerIdList.length; x++){
                          if(widget.name == widget.nameTypeBarcodeTriggerIdList[x]['name']){
                            widget.nameTypeBarcodeTriggerIdList[x]['type'] = value;
                          }
                        }
                      });
                    },
                  ),
                ),
              ),
            ),),
          ],
        ),
      ),
    );
  }
}


