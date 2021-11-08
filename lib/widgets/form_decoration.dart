import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';

InputDecoration formDecoration(Size size) => InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: '',
      enabled: true,
      hintStyle: TextStyle(
        fontSize: size.height * .04,
        color: Colors.grey,
        fontFamily: 'mulish',
        //fontWeight: FontWeight.bold
      ),
      border: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      disabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
      errorBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6.57)),
          borderSide: BorderSide.none),
    );

InputDecoration textFieldFormDecoration(Size size) => InputDecoration(


          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF4caf50)),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Color(0xFF4caf50)),
            borderRadius: BorderRadius.circular(10),
          ),


    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
    isDense: true,
    border: new OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.0),
        borderSide: new BorderSide(color: Colors.grey)),

    hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: size.height * .05,
        fontWeight: FontWeight.w500),);

InputDecoration textFieldFormDecorationLogin(Size size,PublicProvider publicProvider) => InputDecoration(


    hintText: 'Enter email or Phone number',
    filled: true,
    fillColor: Colors.blueGrey[50],
    labelStyle: TextStyle(fontSize:publicProvider.isWindows? size.height*.02:size.width*.02,),
    contentPadding: EdgeInsets.only(left: 30),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green.shade100),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.green.shade100),
      borderRadius: BorderRadius.circular(15),
    ),


);
