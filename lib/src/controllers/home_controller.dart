import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeController extends ControllerMVC {
  Barcode result;
  QRViewController qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    notifyListeners();
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      notifyListeners();
    });
  }
}
