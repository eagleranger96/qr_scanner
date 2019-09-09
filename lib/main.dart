import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

import './qr_display.dart';

void main() => runApp(
      MaterialApp(
        title: "QR Scanner",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.green,
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime currentBackPressTime = DateTime.now().subtract(Duration(seconds: 5));

  Future scan(BuildContext context) async {
    try {
      String barcode = await BarcodeScanner.scan();
      _textEditingController.text = barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              "No camera permission",
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            duration: Duration(seconds: 2),
            content: Text(
              "An error has occurred",
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } on FormatException catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "Nothing Scanned",
            textAlign: TextAlign.center,
          ),
        ),
      );
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "An error has occurred",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              DateTime now = DateTime.now();
              if (now.difference(currentBackPressTime) < Duration(seconds: 2)) {
                return Future.value(true);
              } else {
                currentBackPressTime = now;
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text(
                      "Press back again to continue",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
                return Future.value(false);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _textEditingController,
                    enableInteractiveSelection: true,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: InputDecoration(
                      hintText: "Scan or put text here to generate QR Code",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      contentPadding: EdgeInsets.all(12.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.content_copy),
                        iconSize: 25.0,
                        onPressed: () {
                          if (_textEditingController.text.length == 0) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  "No text to copy",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          } else {
                            Clipboard.setData(
                              ClipboardData(text: _textEditingController.text),
                            );
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                duration: Duration(seconds: 2),
                                content: Text(
                                  "Copied to Clipboard",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    child: Text("Generate QR Code"),
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    onPressed: () {
                      if (_textEditingController.text.length == 0) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            content: Text(
                              "Please enter some text to generate QR Code",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrDisplay(
                              qrString: _textEditingController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: Icon(Icons.camera_alt),
            onPressed: () {
              scan(context);
            },
          );
        },
      ),
    );
  }
}
