import 'dart:io';

import 'package:examplescan/src/controllers/home_controller.dart';
import 'package:examplescan/src/helpers/animationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  // final camera;

  // HomeScreen(
  //   this.camera,
  // );

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends StateMVC<HomeScreen> with SingleTickerProviderStateMixin {
  HomeController _con;
  double height;
  double width;

  AnimationController _animationController;
  bool _animationStopped = true;
  bool scanning = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _con.qrController.pauseCamera();
    }
    _con.qrController.resumeCamera();
  }

  _HomeScreenState() : super(HomeController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(duration: new Duration(seconds: 5), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    animateScanAnimation(false);
    scanning = true;
    _animationStopped = false;
    // _con.listFirst(widget.camera);
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Container(child: _buildQrView(context)),
          Container(
            child: ImageScannerAnimation(
              _animationStopped,
              width,
              height,
              animation: _animationController,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: width * 0.1, left: width * 0.03),
              child: Container(
                height: width * 0.1,
                width: width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  // borderRadius: BorderRadius.all(),
                ),
                child: Icon(
                  Icons.close,
                  size: 25,
                  color: Colors.white,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: height * 0.8, left: width * 0.05, right: width * 0.05, bottom: height * 0.05),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              margin: EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 16.0),
              //color: Colors.blue[50],
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                    margin: EdgeInsets.only(right: 8, left: 0, top: 8, bottom: 8),
                    width: 78,
                    height: 78,
                    child:
                        Image.network("https://cdn.iconscout.com/icon/premium/png-512-thumb/broccoli-11-136267.png")),
                Container(
                    width: width * 0.38,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            // margin: EdgeInsets.only(left: width * 0.03),
                            child: Text("Broccoli",
                                style: TextStyle(
                                    color: Colors.black, fontSize: width * 0.06, fontWeight: FontWeight.bold))),
                        SizedBox(height: height * 0.01),
                        Container(
                            // margin: EdgeInsets.only(left: width * 0.03),
                            child: Text("Expire 10 Jan",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: width * 0.04, fontWeight: FontWeight.w400))),
                      ],
                    )),
                Container(
                  height: width * 0.1,
                  width: width * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.add,
                    size: 25,
                    color: Colors.white,
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: _con.qrKey,
      onQRViewCreated: _con.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.black12, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
    );
  }
}
