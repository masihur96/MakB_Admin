
import 'package:flutter/material.dart';
import 'package:makb_admin_pannel/main_page.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:makb_admin_pannel/pages/login_page.dart';
import 'package:makb_admin_pannel/provider/firebase_provider.dart';
import 'package:makb_admin_pannel/provider/public_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //await firebase_core.Firebase.initializeApp();
  runApp( MyApp(),);
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  Map<int, Color> color = {
    //RGB Color Code (0, 194, 162)
    50: Color.fromRGBO(188, 158, 87, .1),
    100: Color.fromRGBO(188, 158, 87,.2),
    200: Color.fromRGBO(188, 158, 87, .3),
    300: Color.fromRGBO(188, 158, 87, .4),
    400: Color.fromRGBO(188, 158, 87, .5),
    500: Color.fromRGBO(188, 158, 87, .6),
    600: Color.fromRGBO(188, 158, 87, .7),
    700: Color.fromRGBO(188, 158, 87, .8),
    800: Color.fromRGBO(188, 158, 87, .9),
    900: Color.fromRGBO(188, 158, 87, 1),
  };
  @override
  Widget build(BuildContext context) {

    return MultiProvider(

      providers: [
        ChangeNotifierProvider(create: (context)=>PublicProvider()),
        ChangeNotifierProvider(create: (context)=>FirebaseProvider()),
      ],
      child: MaterialApp(

        title: 'Mak-B Admin Panel',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.blueGrey.shade50,
          primarySwatch: MaterialColor(0xffBC9E57, color),
          canvasColor: Colors.transparent
        ),
        home: MainPage(),
      ),
    );
  }
}