import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:http/http.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../logout.dart';
import 'multioccurrenceday.dart';
import 'listinstance.dart';
import '../login.dart';
import 'package:flutter/cupertino.dart';
import 'adminlisttemplate.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:intl/intl.dart';


class CreateChecklistSchedule extends StatefulWidget {
  const CreateChecklistSchedule({Key? key}) : super(key: key);

  @override
  _CreateChecklistScheduleState createState() => _CreateChecklistScheduleState();
}

class _CreateChecklistScheduleState extends State<CreateChecklistSchedule> {

  @override
  void didChangeDependencies(){
    Future.delayed(Duration(seconds: 2)).then((value){
      if(mounted){
        getTemplates = create(context);
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    try {
      sb!.close();
    } catch(e){
      print('no snackbar');
    }
    super.dispose();
  }

  void refresh() {
    setState(() {
    });
  }

  TimeOfDay? tempTime;
  DateTime? deadline;
  String recurring = 'daily';
  PickerDateRange? dateRange;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  TextEditingController scheduleNameController = new TextEditingController();
  Future<List<Widget>>? getTemplates;
  List departments = [];
  List scheduledTemplates = [];
  List days = [];
  bool refreshed = false;
  Map<String, dynamic> monthlyDate = {
    'numberOfOccurrence': '0',
    'date': 'none',
    'times': {}
  };
  bool multipleAppearances = false;
  List multiOccurrenceDays = [new MultiOccurrenceDay(day: 'sunday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'monday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'tuesday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'wednesday', numberOfOccurrence: 0),
    new MultiOccurrenceDay(day: 'thursday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'friday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'saturday', numberOfOccurrence: 0),];
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CREATE SCHEDULE"),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.lightBlue,
                  Colors.green,
                  Colors.yellow,
                ]
            )
        ),
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: [
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Container(
                constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 1),
                padding: EdgeInsets.only(left: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.275, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.05)]).value!, right: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.275, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.05)]).value!,),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                        ),
                      ),
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
                      child: Column(
                        children: [
                          Container(child: Text('SCHEDULE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.09,),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'NAME',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.amber,
                                    ),
                                  ),
                                ),
                                controller: scheduleNameController,
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'RECURRING',
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      dropdownColor: Colors.amber,
                                      isExpanded: true,
                                      underline: Container(height: 1, color: Colors.black),
                                      hint: Text(recurring, style: TextStyle(color: Colors.white)),
                                      items: <String>[
                                        'daily',
                                        'weekly',
                                        'monthly',
                                      ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String> (
                                          value: value,
                                          child: Text(value, style: TextStyle(color: Colors.black),),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        recurring = value!;
                                        refreshed = false;
                                        refresh();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'RANGE',
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateRange == null ? 'Date Range' : dateRange!.startDate.toString().split(' ')[0] + ' - ' + dateRange!.endDate.toString().split(' ')[0],
                                    style: TextStyle(
                                        color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.schedule, color: Colors.white),
                                    onPressed: (){
                                      showDialog(
                                          context: context,
                                          builder: (context){
                                            return Scaffold(
                                              backgroundColor: Colors.transparent,
                                              body: AlertDialog(
                                                backgroundColor: Colors.transparent,
                                                content: Container(
                                                  width: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.45, valueWhen: [Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 0.9,)]).value!,
                                                  height: MediaQuery.of(context).size.height * 0.55,
                                                  child: SfDateRangePicker(
                                                    selectionTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                                    rangeTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
                                                    startRangeSelectionColor: Colors.greenAccent,
                                                    endRangeSelectionColor: Colors.greenAccent,
                                                    selectionColor: Colors.greenAccent,
                                                    rangeSelectionColor: Colors.greenAccent.withOpacity(0.70),
                                                    backgroundColor: Colors.black87,
                                                    view: DateRangePickerView.month,
                                                    monthViewSettings: DateRangePickerMonthViewSettings(
                                                      viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                                        textStyle: TextStyle(color: Colors.amber),
                                                      ),
                                                    ),
                                                    yearCellStyle: DateRangePickerYearCellStyle(
                                                      textStyle: TextStyle(color: Colors.white),
                                                    ),
                                                    headerStyle: DateRangePickerHeaderStyle(
                                                      textStyle: TextStyle(color: Colors.amber),
                                                    ),
                                                    monthCellStyle: DateRangePickerMonthCellStyle(
                                                      textStyle: TextStyle(color: Colors.white),
                                                    ),
                                                    selectionMode: DateRangePickerSelectionMode.extendableRange,
                                                    showActionButtons: true,
                                                    onCancel: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    onSubmit: (value){
                                                      try {
                                                        dateRange = value as PickerDateRange?;
                                                        monthlyDate['date'] = dateRange!.startDate!.day.toString();
                                                        if(dateRange == null){
                                                          dateRange = new PickerDateRange(DateTime(0), DateTime(0));
                                                        }
                                                        setState(() {
                                                        });
                                                        Navigator.of(context).pop();
                                                      } catch(e){
                                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text('Please Choose A Range!'),
                                                            action: SnackBarAction(
                                                              label: 'okay',
                                                              onPressed: () {
                                                                // Code to execute.
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          Column(
                            children: [
                              Row(
                                  children: [
                                    Text(
                                      'CUSTOM',
                                      style: TextStyle(
                                        color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ]
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Specific Days?',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Checkbox(
                                    activeColor: Colors.green,
                                    side: BorderSide(color: Colors.white),
                                    value: multipleAppearances,
                                    onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                      setState(() {
                                        multipleAppearances = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              multipleAppearances == true && recurring == 'daily' ? ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: multiOccurrenceDays.length,
                                itemBuilder: (BuildContext context, int index) {
                                  MultiOccurrenceDay temp = multiOccurrenceDays[index] as MultiOccurrenceDay;
                                  return Container(
                                    constraints: BoxConstraints(
                                      minHeight: MediaQuery.of(context).size.height * 0.05,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(temp.day!, style: TextStyle(color: Colors.white)),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.15,
                                                child: DropdownButton<int>(
                                                  dropdownColor: Colors.amber,
                                                  menuMaxHeight: MediaQuery.of(context).size.height * 0.2,
                                                  hint: Text(temp.numberOfOccurrence.toString(), style: TextStyle(color: Colors.white)),
                                                  isExpanded: true,
                                                  icon: Icon(Icons.format_list_numbered),
                                                  items: <int>[
                                                    0,
                                                    1,
                                                    2,
                                                    3,
                                                    4,
                                                    5,
                                                  ].map<DropdownMenuItem<int>>((int value) {
                                                    return DropdownMenuItem<int> (
                                                      value: value,
                                                      child: Text(value.toString(), style: TextStyle(color: Colors.black)),
                                                    );
                                                  }).toList(),
                                                  onChanged: (int? value) {
                                                    setState(() {
                                                      temp.numberOfOccurrence = value!;
                                                      temp.times = {};
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        temp.numberOfOccurrence == 0 ? Container() : ListView.builder(
                                            itemCount: temp.numberOfOccurrence,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemBuilder: (context, index){
                                              return Row(
                                                children: [
                                                  TextButton(
                                                    child: Text('StartTime ${index + 1}', style: TextStyle(color: Colors.amber)),
                                                    onPressed: () async {
                                                      try {
                                                        TimeOfDay tmp = await showTimePicker(
                                                          context: context,
                                                          initialTime: TimeOfDay(hour: 24, minute: 0),
                                                          initialEntryMode: TimePickerEntryMode.input,
                                                        ).then((value){
                                                          temp.times[(index + 1).toString()] = DateFormat.Hm().format(DateTime(0, 0, 0, value!.hour, value.minute));
                                                          setState((){});
                                                          return TimeOfDay(minute: 0, hour: 0);
                                                        });
                                                      } catch(e){

                                                      }
                                                    },
                                                  ),
                                                  Text(temp.times[(index + 1).toString()].toString() == 'null' ? '' : temp.times[(index + 1).toString()]!, style: TextStyle(color: Colors.white)),
                                                ],
                                              );
                                            }
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ) : multipleAppearances == true && recurring == 'weekly' && dateRange != null ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(dateRange != null ? (dateRange!.startDate!.weekday == 0 ? 'Sunday' : (dateRange!.startDate!.weekday == 1 ? 'Monday' : (dateRange!.startDate!.weekday == 2 ? 'Tuesday' :
                                      (dateRange!.startDate!.weekday == 3 ? 'Wednesday' : (dateRange!.startDate!.weekday == 4 ? 'Thursday' : (dateRange!.startDate!.weekday == 5 ? 'Friday' : dateRange!.startDate!.weekday == 6 ? 'Saturday' : '')))))) : '', style: TextStyle(color: Colors.white)),
                                      dateRange != null ? Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.15,
                                          child: DropdownButton<int>(
                                            dropdownColor: Colors.amber,
                                            menuMaxHeight: MediaQuery.of(context).size.height * 0.2,
                                            hint: Text(dateRange!.startDate!.weekday == 0 ? (multiOccurrenceDays[0] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            (dateRange!.startDate!.weekday == 1 ? (multiOccurrenceDays[1] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            (dateRange!.startDate!.weekday == 2 ? (multiOccurrenceDays[2] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            (dateRange!.startDate!.weekday == 3 ? (multiOccurrenceDays[3] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            (dateRange!.startDate!.weekday == 4 ? (multiOccurrenceDays[4] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            (dateRange!.startDate!.weekday == 5 ? (multiOccurrenceDays[5] as MultiOccurrenceDay).numberOfOccurrence.toString() :
                                            dateRange!.startDate!.weekday == 6 ? (multiOccurrenceDays[6] as MultiOccurrenceDay).numberOfOccurrence.toString() : ''))))), style: TextStyle(color: Colors.white)),
                                            isExpanded: true,
                                            icon: Icon(Icons.format_list_numbered),
                                            items: <int>[
                                              0,
                                              1,
                                              2,
                                              3,
                                              4,
                                              5,
                                            ].map<DropdownMenuItem<int>>((int value) {
                                              return DropdownMenuItem<int> (
                                                value: value,
                                                child: Text(value.toString(), style: TextStyle(color: Colors.black)),
                                              );
                                            }).toList(),
                                            onChanged: (int? value) {
                                              setState(() {
                                                switch(dateRange!.startDate!.weekday){
                                                  case 0:
                                                    (multiOccurrenceDays[0] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[0] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 1:
                                                    (multiOccurrenceDays[1] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[1] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 2:
                                                    (multiOccurrenceDays[2] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[2] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 3:
                                                    (multiOccurrenceDays[3] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[3] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 4:
                                                    (multiOccurrenceDays[4] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[4] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 5:
                                                    (multiOccurrenceDays[5] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[5] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  case 6:
                                                    (multiOccurrenceDays[6] as MultiOccurrenceDay).numberOfOccurrence = value!;
                                                    (multiOccurrenceDays[6] as MultiOccurrenceDay).times = {};
                                                    break;
                                                  default:
                                                    break;
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                      ) : Text('Haven\'t chosen a date range!', style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  (multiOccurrenceDays[dateRange!.startDate!.weekday] as MultiOccurrenceDay).numberOfOccurrence == 0 ? Container() : ListView.builder(
                                      itemCount: (multiOccurrenceDays[dateRange!.startDate!.weekday] as MultiOccurrenceDay).numberOfOccurrence,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index){
                                        return Row(
                                          children: [
                                            TextButton(
                                              child: Text('StartTime ${index + 1}', style: TextStyle(color: Colors.amber)),
                                              onPressed: () async {
                                                await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay(hour: 24, minute: 0),
                                                  initialEntryMode: TimePickerEntryMode.input,
                                                ).then((value) => {
                                                  (multiOccurrenceDays[dateRange!.startDate!.weekday] as MultiOccurrenceDay).times[(index + 1).toString()] = DateFormat.Hm().format(DateTime(0, 0, 0, value!.hour, value.minute)),
                                                  setState((){}),
                                                });
                                              },
                                            ),
                                            Text((multiOccurrenceDays[dateRange!.startDate!.weekday] as MultiOccurrenceDay).times[(index + 1).toString()].toString() == 'null' ? '' : (multiOccurrenceDays[dateRange!.startDate!.weekday] as MultiOccurrenceDay).times[(index + 1).toString()]!, style: TextStyle(color: Colors.white)),
                                          ],
                                        );
                                      }
                                  ),
                                ],
                              ) :
                              multipleAppearances == true && recurring == 'monthly' && dateRange != null ? Container(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(dateRange!.startDate!.day.toString(), style: TextStyle(color: Colors.white)),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.15,
                                            child: DropdownButton<int>(
                                              dropdownColor: Colors.amber,
                                              menuMaxHeight: MediaQuery.of(context).size.height * 0.2,
                                              hint: Text(monthlyDate['numberOfOccurrence'].toString(), style: TextStyle(color: Colors.white)),
                                              isExpanded: true,
                                              icon: Icon(Icons.format_list_numbered),
                                              items: <int>[
                                                0,
                                                1,
                                                2,
                                                3,
                                                4,
                                                5,
                                              ].map<DropdownMenuItem<int>>((int value) {
                                                return DropdownMenuItem<int> (
                                                  value: value,
                                                  child: Text(value.toString(), style: TextStyle(color: Colors.black)),
                                                );
                                              }).toList(),
                                              onChanged: (int? value) {
                                                setState(() {
                                                  monthlyDate['numberOfOccurrence'] = value!.toString();
                                                  monthlyDate['times'] = {};
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    int.parse(monthlyDate['numberOfOccurrence']) == 0 ? Container() : ListView.builder(
                                        itemCount: int.parse(monthlyDate['numberOfOccurrence']),
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index){
                                          return Row(
                                            children: [
                                              TextButton(
                                                child: Text('StartTime ${index + 1}', style: TextStyle(color: Colors.amber)),
                                                onPressed: () async {
                                                  await showTimePicker(
                                                    context: context,
                                                    initialTime: TimeOfDay(hour: 24, minute: 0),
                                                    initialEntryMode: TimePickerEntryMode.input,
                                                  ).then((value) => {
                                                    monthlyDate['times'][(index + 1).toString()] = DateFormat.Hm().format(DateTime(0, 0, 0, value!.hour, value.minute)),
                                                    setState((){}),
                                                  });
                                                },
                                              ),
                                              Text(monthlyDate['times'][(index + 1).toString()].toString() == 'null' ? '' : monthlyDate['times'][(index + 1).toString()]!, style: TextStyle(color: Colors.white)),
                                            ],
                                          );
                                        }
                                    ),
                                  ],
                                ),
                              ) : multipleAppearances == false ? Container() : Container(
                                child: Text('Please choose a date range!', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          multipleAppearances == false ? Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'START TIME',
                                    style: TextStyle(
                                      color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    startTime == null ? 'Starting Time' : startTime!.format(context),
                                    style: TextStyle(color: Colors.white)
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.amber,
                                    ),
                                    onPressed: () async {
                                      startTime = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay(hour: 24, minute: 0),
                                        initialEntryMode: TimePickerEntryMode.input,
                                      );
                                      setState((){});
                                    },
                                    child: Text('Choose Time', style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                            ],
                          ) : Container(),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          Text(
                            'TEMPLATES',
                            style: TextStyle(
                              color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: (){
                              showAnimatedDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  animationType: DialogTransitionType.slideFromBottomFade,
                                  curve: Curves.fastOutSlowIn,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                      builder: (BuildContext context, void Function(void Function()) setState) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black45,
                                          title: Text('Templates', style: TextStyle(color: Colors.white)),
                                          content: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(0.5),
                                                  Colors.black.withOpacity(0.2),
                                                ],
                                                begin: AlignmentDirectional.topStart,
                                                end: AlignmentDirectional.bottomEnd,
                                              ),
                                              border: Border.all(
                                                width: 1.5,
                                                color: Colors.black.withOpacity(0.2),
                                              ),
                                            ),
                                            height: MediaQuery.of(context).size.height * 0.5,
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            child: FutureBuilder(
                                              future: getTemplates,
                                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.connectionState == ConnectionState.done) {
                                                  if (snapshot.hasError) {
                                                    return const Text('Error');
                                                  } else if (snapshot.hasData) {
                                                    List<Widget> templates = snapshot.data as List<Widget>;
                                                    return Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        templates.length == 0 ? Text('PLEASE CREATE MORE TEMPLATES') : Expanded(
                                                          flex: 8,
                                                          child: Container(
                                                            child: ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount: templates.length,
                                                                itemBuilder: (context, index){
                                                                  ListTemplate listTemplate = templates[index] as ListTemplate;
                                                                  return Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                          child: Checkbox(
                                                                            activeColor: Colors.green,
                                                                            side: BorderSide(color: Colors.white),
                                                                            value: listTemplate.templateSelected,
                                                                            onChanged: (bool? value) { // This is where we update the state when the checkbox is tapped
                                                                              setState(() {
                                                                                listTemplate.templateSelected = value!;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(flex: 7, child: Container(child: Text(listTemplate.name, style: TextStyle(color: Colors.white)))),
                                                                      listTemplate.templateSelected == true ? Expanded(
                                                                        flex: 3,
                                                                        child: Container(
                                                                          width: MediaQuery.of(context).size.width * 0.35,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                                                            child: DropdownButton<int>(
                                                                              dropdownColor: Colors.amber,
                                                                              menuMaxHeight: MediaQuery.of(context).size.height * 0.2,
                                                                              hint: Text(listTemplate.timeToFinish.toString().length == 1 ? '${listTemplate.timeToFinish.toString()} HRS' :
                                                                              (listTemplate.timeToFinish.toString().length == 2 ? '${listTemplate.timeToFinish.toString()} MINS' :
                                                                              '${listTemplate.timeToFinish.toString()[0]} HRS ${listTemplate.timeToFinish.toString()[1]}${listTemplate.timeToFinish.toString()[2]} MINS'), style: TextStyle(color: Colors.white)),
                                                                              isExpanded: true,
                                                                              icon: Icon(Icons.timer),
                                                                              items: <int>[
                                                                                30,
                                                                                1,
                                                                                130,
                                                                                2,
                                                                              ].map<DropdownMenuItem<int>>((int value) {
                                                                                String view = '';
                                                                                String temp = value.toString();
                                                                                if(temp.length == 1){
                                                                                  view += temp;
                                                                                  view += ' HRS';
                                                                                } else if(temp.length == 2){
                                                                                  view += temp;
                                                                                  view += ' MINS';
                                                                                } else {
                                                                                  view += temp[0];
                                                                                  view += ' HRS ';
                                                                                  view += temp[1];
                                                                                  view += temp[2];
                                                                                  view += ' MINS';
                                                                                }
                                                                                return DropdownMenuItem<int> (
                                                                                  value: value,
                                                                                  child: Text(view, style: TextStyle(color: Colors.black)),
                                                                                );
                                                                              }).toList(),
                                                                              onChanged: (int? value) {
                                                                                setState(() {
                                                                                  listTemplate.timeToFinish = value!;
                                                                                });
                                                                              },
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ) : Expanded(flex: 3, child: Container()),
                                                                    ],
                                                                  );
                                                                  return Container();
                                                                }
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                TextButton(
                                                                  onPressed: (){
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text(
                                                                      'Exit'
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: (){
                                                                    for(var x = 0; x < templates.length; x++){
                                                                      ListTemplate temp = templates[x] as ListTemplate;
                                                                      if(temp.templateSelected == true){
                                                                        if(scheduledTemplates.isEmpty){
                                                                          Map map = {
                                                                            temp.name: temp.timeToFinish
                                                                          };
                                                                          scheduledTemplates.add(map);
                                                                        } else {
                                                                          Map map = {};
                                                                          scheduledTemplates.forEach((element) {
                                                                            Map e = element as Map;
                                                                            map[e.keys.toList()[0]] = e.values.toList()[0];
                                                                          });
                                                                          if(map.containsKey(temp.name)){
                                                                            //replaced
                                                                          } else {
                                                                            Map template = {};
                                                                            template[temp.name] = temp.timeToFinish;
                                                                            scheduledTemplates.add(template);
                                                                          }
                                                                        }
                                                                      }
                                                                    }
                                                                    refreshed = false;
                                                                    refresh();
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text(
                                                                      'Submit'
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  } else {
                                                    return const Text('Empty data');
                                                  }
                                                } else {
                                                  return Text('State: ${snapshot.connectionState}');
                                                }
                                              }
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                              );
                            },
                          ),
                          ListView.builder(
                              itemCount: scheduledTemplates.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index){
                                Map scheduledTemplate = scheduledTemplates[index] as Map;
                                return ListTile(
                                  title: Text(scheduledTemplate.keys.toList()[0], style: TextStyle(color: Colors.white)),
                                );
                              }
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.075,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.amber,
                            ),
                            onPressed: (){
                              bool canSubmit = true;
                              if(multipleAppearances == true && recurring == 'daily'){
                                for(int x = 0; x < multiOccurrenceDays.length; x++){
                                  MultiOccurrenceDay day = multiOccurrenceDays[x] as MultiOccurrenceDay;
                                  if(day.numberOfOccurrence == day.times.length && day.times.length != 0){
                                    Map temp = {};
                                    temp['day'] = day.day;
                                    temp['times'] = day.times;
                                    temp['dayOfWeek'] = x.toString();
                                    days.add(temp);
                                  } else if(day.numberOfOccurrence != day.times.length && day.times.length != 0){
                                    canSubmit = false;
                                    days.clear();
                                    break;
                                  }
                                }
                              } else if(multipleAppearances == true && recurring == 'weekly'){
                                for(int x = 0; x < multiOccurrenceDays.length; x++){
                                  MultiOccurrenceDay day = multiOccurrenceDays[x] as MultiOccurrenceDay;
                                  if(day.numberOfOccurrence == day.times.length && day.times.length != 0){
                                    Map temp = {};
                                    temp['day'] = day.day;
                                    temp['dayOfWeek'] = x.toString();
                                    temp['times'] = day.times;
                                    days.add(temp);
                                  } else if(day.numberOfOccurrence != day.times.length && day.times.length != 0){
                                    canSubmit = false;
                                    days.clear();
                                    break;
                                  }
                                }
                              } else if(multipleAppearances == true && recurring == 'monthly'){
                                if(int.parse(monthlyDate['numberOfOccurrence']) != monthlyDate['times'].length){
                                  //replaced
                                  canSubmit = false;
                                } else {
                                  //replaced
                                }
                              }
                              if(scheduleNameController.text == '' || recurring == '' || dateRange == PickerDateRange(DateTime(0), DateTime(0)) || dateRange == null || scheduledTemplates.length == 0){
                                canSubmit = false;
                              }
                              if(multipleAppearances == false && startTime == null){
                                canSubmit = false;
                              }
                              if(dateRange!.startDate == null ||  dateRange!.endDate == null){
                                canSubmit = false;
                              }
                              if(canSubmit == true){
                                submitSchedule().then((value) => {
                                  if(value == 'successful'){
                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Schedule successfully created!'),
                                        action: SnackBarAction(
                                          label: 'Okay',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    )
                                  } else if(value == 'error'){
                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Could not create schedule...'),
                                        action: SnackBarAction(
                                          label: 'Okay',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    )
                                  } else {
                                    sb = ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Can\'t create schedule, not on the network!'),
                                        action: SnackBarAction(
                                          label: 'Okay',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    )
                                  }
                                });
                              } else {
                                sb = ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Invalid inputs, make sure all fields are filled and the entries are all correct!'),
                                    action: SnackBarAction(
                                      label: 'Okay',
                                      onPressed: () {
                                        // Code to execute.
                                      },
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Text('Submit', style: TextStyle(color: Colors.black)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> submitSchedule() async {
    String? responseBody;
    Response? responses;

    String? timeStart;
    if(multipleAppearances == true){
      timeStart = 'None';
    } else {
      timeStart = DateFormat.Hm().format(DateTime(0, 0, 0, startTime!.hour, startTime!.minute));
    }

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/schedule/insert/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'multiDays': jsonEncode(days),'multipleAppearances': multipleAppearances.toString(),'scheduleName': scheduleNameController.text, 'recurring': recurring, 'dateRangeStart': dateRange!.startDate.toString(),
        'dateRangeEnd': dateRange!.endDate.toString(), 'startTime': timeStart, 'templatesToSchedule': jsonEncode(scheduledTemplates), 'monthlyDate': jsonEncode(monthlyDate), 'location': Login.location, 'onNetwork': Login.onNetwork.toString(),
      }).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      sb = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not connect to server!'),
          action: SnackBarAction(
            label: 'okay',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      return 'error';
    }
    monthlyDate = {
      'numberOfOccurrence': '0',
      'date': 'none',
      'times': {}
    };
    days = [];
    scheduledTemplates = [];
    scheduleNameController.text = '';
    recurring = '';
    dateRange = null;
    startTime = null;
    endTime = null;
    multipleAppearances = false;
    multiOccurrenceDays = [new MultiOccurrenceDay(day: 'sunday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'monday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'tuesday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'wednesday', numberOfOccurrence: 0),
      new MultiOccurrenceDay(day: 'thursday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'friday', numberOfOccurrence: 0), new MultiOccurrenceDay(day: 'saturday', numberOfOccurrence: 0),];
    refreshed = false;
    refresh();
    var json = await jsonDecode(responseBody!);
    try{
      if(json['status'] == 'no-session'){
        sb = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid Session, logging out...'),
            action: SnackBarAction(
              label: 'okay',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        Timer(Duration(seconds: 3), () {
          Logout.logout().then((value) async {
            if(value == 'successful'){
              final storage = await SharedPreferences.getInstance();
              storage.remove('login');
              storage.remove('sessionId');
              storage.remove('userId');
              storage.remove('admin');
              storage.remove('userPermissions');
              storage.remove('jobPermissions');
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            } else {
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not log you out...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
          });
        });
      }
    } catch (e){
      //replaced
    }
    return json['status'];
  }
  Future<List<Widget>> create(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List<ListTemplate> items = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/checklist/template/');
    try {
      await HttpClientHelper.get(url, timeLimit: Duration(seconds: 5), headers: {'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
        responseBody = response!.body,
        responses = response
      });
    } catch(e){
      sb = ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not connect to server!'),
          action: SnackBarAction(
            label: 'okay',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
      return [];
    }
    var json = await jsonDecode(responseBody!);
    try{
      if(json['status'] == 'no-session'){
        sb = ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid Session, logging out...'),
            action: SnackBarAction(
              label: 'okay',
              onPressed: () {
                // Code to execute.
              },
            ),
          ),
        );
        Timer(Duration(seconds: 3), () {
          Logout.logout().then((value) async {
            if(value == 'successful'){
              final storage = await SharedPreferences.getInstance();
              storage.remove('login');
              storage.remove('sessionId');
              storage.remove('userId');
              storage.remove('admin');
              storage.remove('userPermissions');
              storage.remove('jobPermissions');
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
            } else {
              sb = ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Could not log you out...'),
                  action: SnackBarAction(
                    label: 'okay',
                    onPressed: () {
                      // Code to execute.
                    },
                  ),
                ),
              );
            }
          });
        });
      }
    } catch (e){
      //replaced
    }
    try {
      ListTemplate? previousListTemplate = new ListTemplate(name: json[0]['templateName'], departmentName: json[0]['departmentName'], templateItems: {json[0]['itemName'] : '${json[0]['itemId']}' + '_' + '${json[0]['itemType']}'},);
      for(int x = 1; x < json.length; x++){
        if(previousListTemplate!.name == json[x]['templateName']){
          previousListTemplate.templateItems['${json[x]['itemName']}'] = '${json[x]['itemId']}';
        } else {
          items.add(previousListTemplate);
          previousListTemplate = new ListTemplate(name: json[x]['templateName'], departmentName: json[x]['departmentName'], templateItems: {json[x]['itemName'] : '${json[x]['itemId']}' + '_' + '${json[x]['itemType']}'},);
        }
      }
      items.add(previousListTemplate!);
    } catch(e) {
      return items;
    }
    return items;
  }
}
