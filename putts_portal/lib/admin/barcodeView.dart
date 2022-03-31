import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:http/http.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:putts_portal/admin/userpermission.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_grid.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../logout.dart';
import 'barcode.dart';
import '../login.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

class barcodeView extends StatefulWidget {
  const barcodeView({Key? key}) : super(key: key);

  @override
  _barcodeViewState createState() => _barcodeViewState();
}

class _barcodeViewState extends State<barcodeView> {

  @override
  void initState(){
    super.initState();
  }

  @override
  void didChangeDependencies(){
    Future.delayed(Duration(seconds: 1)).then((value){
      setState(() {
        retrievedBarcodes = getBarcodes(context);
      });
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

  void refresh(){
    setState(() {
    });
  }

  ScreenshotController screenshotController = ScreenshotController();
  TextEditingController textController = new TextEditingController();
  Future<List>? retrievedBarcodes;
  bool refreshed = false;
  ScaffoldFeatureController? sb;

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: retrievedBarcodes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.black,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDancingSquare(
                          color: Colors.white,
                        ),
                        Text('Loading...',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: MediaQuery.of(context).size.width * 0.02
                            ))
                      ],
                    )
                ),
              ));
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Text('Error');
          } else if (snapshot.hasData) {
            print('contain data');
            List barcodes = snapshot.data;
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.black87,
                  title: Text('BARCODES'),
                  actions: [
                    UserPermission.getAllPermissions().contains('add barcode') ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          showAnimatedDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Scaffold(
                                backgroundColor: Colors.transparent,
                                body: StatefulBuilder(
                                    builder: (context, setState){
                                      return AlertDialog(
                                        backgroundColor: Colors.black45,
                                        title: Text('Add Barcode?', style: TextStyle(color: Colors.white)),
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
                                          alignment: Alignment.center,
                                          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.3, maxHeight: MediaQuery.of(context).size.height * 0.3, minWidth: MediaQuery.of(context).size.width * 0.7, maxWidth: MediaQuery.of(context).size.width * 0.7),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context).size.width * 0.6,
                                                child: TextFormField(
                                                  controller: textController,
                                                  style: TextStyle(color: Colors.white),
                                                  decoration: InputDecoration(
                                                      helperText: "Name",
                                                      helperStyle: TextStyle(color: Colors.white),
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
                                                      )
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                        "EXIT",
                                                        style: TextStyle(color: Colors.amber)
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: (){
                                                      if(textController.text != ""){
                                                        addBarcode(textController.text, context).then((value) => {
                                                          if(value == 'successful'){
                                                            textController.text = '',
                                                            Navigator.of(context).pop(),
                                                            retrievedBarcodes = getBarcodes(context),
                                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: const Text('Successfully added barcode!'),
                                                                action: SnackBarAction(
                                                                  label: 'okay',
                                                                  onPressed: () {
                                                                    // Code to execute.
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          } else if(value == 'network'){
                                                            textController.text = '',
                                                            Navigator.of(context).pop(),
                                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: const Text('Must be on the network!'),
                                                                action: SnackBarAction(
                                                                  label: 'okay',
                                                                  onPressed: () {
                                                                    // Code to execute.
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          } else {
                                                            textController.text = '',
                                                            Navigator.of(context).pop(),
                                                            sb = ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(
                                                                content: const Text('Could not add barcode...'),
                                                                action: SnackBarAction(
                                                                  label: 'okay',
                                                                  onPressed: () {
                                                                    // Code to execute.
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          }
                                                        });
                                                      } else {
                                                        sb = ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text('Barcode can\'t be empty!'),
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
                                                    child: Text(
                                                      "SUBMIT",
                                                      style: TextStyle(color: Colors.amber),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              );
                            },
                            animationType: DialogTransitionType.size,
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                    ) : Container(),
                  ],
                ),
                body: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 1),
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
                  child: barcodes.isEmpty ? Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.95,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
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
                    padding: EdgeInsets.all(20),
                    child: Text('NO BARCODES', style: TextStyle(color: Colors.white)),
                  ) : ResponsiveGridView.builder(
                      itemCount: barcodes.length,
                      shrinkWrap: true,
                      gridDelegate: ResponsiveGridDelegate(
                        childAspectRatio: ResponsiveValue(context, defaultValue: 2.5, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: 4.0), Condition.smallerThan(name: TABLET, value: 5.0)]).value!,
                        crossAxisExtent: ResponsiveValue(context, defaultValue: MediaQuery.of(context).size.width * 0.25, valueWhen: [Condition.smallerThan(name: "LAPTOP", value: MediaQuery.of(context).size.width * 0.5), Condition.smallerThan(name: TABLET, value: MediaQuery.of(context).size.width * 1)]).value!,
                      ),
                      itemBuilder: (context, index) {
                        Barcode barcode = barcodes[index] as Barcode;
                        SfBarcodeGenerator sfBarcode = SfBarcodeGenerator(
                          value: barcode.barcodeValue,
                          symbology: Code128(),
                          showValue: true,
                        );
                        return Container(
                          margin: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  child: Screenshot(
                                    controller: barcode.screenshotController,
                                    child: sfBarcode,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  child: ResponsiveRowColumn(
                                    layout: ResponsiveValue(context, defaultValue: ResponsiveRowColumnType.COLUMN, valueWhen: [Condition.smallerThan(name: TABLET, value: ResponsiveRowColumnType.ROW)]).value!,
                                    columnMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ResponsiveRowColumnItem(
                                        child: IconButton(
                                            onPressed: () async {
                                              PdfPreview? pdf;
                                              await barcode.screenshotController.captureFromWidget(sfBarcode).then((Uint8List? image) async {
                                                pdf = PdfPreview(
                                                  build: (format) async => await _generatePdf(format, 'pdf', image),
                                                );
                                              });
                                              showAnimatedDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context) {
                                                  // return pdf as PdfPreview;
                                                  return Container(
                                                    child: pdf,
                                                  );
                                                },
                                                animationType: DialogTransitionType.size,
                                                curve: Curves.fastOutSlowIn,
                                              );
                                            },
                                            icon: Icon(Icons.print)
                                        ),
                                      ),
                                      ResponsiveRowColumnItem(
                                        child: IconButton(
                                            onPressed: () async {
                                              deleteBarcode(barcode.barcodeId!, context).then((value) => {
                                                if(value == 'successful'){
                                                  setState((){
                                                    retrievedBarcodes = getBarcodes(context);
                                                  }),
                                                } else if(value == 'network'){
                                                  sb = ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: const Text('Not on the network!'),
                                                        action: SnackBarAction(
                                                          label: 'Undo',
                                                          onPressed: () {
                                                            // Some code to undo the change.
                                                          },
                                                        ),
                                                      )
                                                  )
                                                } else {
                                                  sb = ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: const Text('Could not delete barcode'),
                                                      action: SnackBarAction(
                                                        label: 'okay',
                                                        onPressed: () {
                                                          // Code to execute.
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.delete)
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                )
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Container(
              height: MediaQuery.of(context).size.height * 1,
              width: MediaQuery.of(context).size.width * 1,
              color: Colors.black,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width * 0.2,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SpinKitDancingSquare(
                          color: Colors.white,
                        ),
                        Text('Loading...',
                            style: TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.none,
                                fontSize: MediaQuery.of(context).size.width * 0.02
                            ))
                      ],
                    )
                ),
              ));
        }
      }
    );
  }

  Future<String> addBarcode(String barcodeValue, BuildContext context) async {
    String? responseBody;
    Response? responses;


    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/barcode/add/');
    try {
      await HttpClientHelper.post(url, timeLimit: Duration(seconds: 5), headers: {'sessionId': Login.sessionId!}, body: {'barcodeValue': barcodeValue, 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
    if(json['status'] == 'successful'){
      setState((){});
    }
    return json['status'];
  }
  Future<List> getBarcodes(BuildContext context) async {
    String? responseBody;
    Response? responses;

    List temp = [];

    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/barcode/');
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
    List barcodes = json['barcodes'];
    for(var x = 0; x < barcodes.length; x++){
      temp.add(new Barcode(barcodeValue: barcodes[x]['barcodeValue'], barcodeId: barcodes[x]['barcodeId']));
    }

    return temp;
  }
  Future<String> deleteBarcode(int barcodeId, BuildContext context) async {
    String? responseBody;
    Response? responses;


    final Uri url = Uri.parse('http://' + Login.localhost + ':8080/barcode/delete/');
    try {
      await HttpClientHelper.delete(url, timeLimit: Duration(seconds: 5), headers: {'barcodeId': barcodeId.toString(), 'location': Login.location!, 'onNetwork': Login.onNetwork.toString(), 'sessionId': Login.sessionId!}).then((Response? response) => {
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
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title, Uint8List? image) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true,);
    final img = pw.MemoryImage(image!);

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.Center(
                child: pw.Container(
                  height: 200,
                  width: double.infinity,
                  child: pw.Image(img, fit: pw.BoxFit.cover),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}
