import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final fadingCircle = SpinKitFadingCircle(
  color: Colors.green,
  size: 50.0,
  // duration: 5,
);
showToast(String message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0
  );
}



showLoaderDialog(BuildContext context){
  AlertDialog alert=AlertDialog(
    content: new Row(
      children: [
        CircularProgressIndicator(),
        Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
      ],),
  );
  showDialog(barrierDismissible: true,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}

