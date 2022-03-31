import 'package:screenshot/screenshot.dart';

class Barcode {

  Barcode({required this.barcodeValue, required this.barcodeId});

  String? barcodeValue;
  int? barcodeId;
  ScreenshotController screenshotController = ScreenshotController();

}