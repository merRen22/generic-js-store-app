import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_store_app/src/UI/orderCompleteScreen.dart';
import 'package:generic_store_app/src/UI/storeScreen.dart';

mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class App extends StatelessWidget with PortraitModeMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme: IconThemeData(color: Colors.grey[800]),
        accentIconTheme: IconThemeData(color: Colors.blue),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        fontFamily: "Open Sans",
        primaryColor: Colors.black,
        primaryTextTheme: TextTheme(
          title: TextStyle(fontSize: 24.0, color: Colors.black),
          subtitle: TextStyle(fontSize: 28.0, color: Colors.black),
          body1: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
          body2: TextStyle(fontSize: 14.0, color: Colors.grey[800],fontWeight: FontWeight.w800),
          display1: TextStyle(fontSize: 14.0, color: Colors.red,fontWeight: FontWeight.w800),
          display2: TextStyle(fontSize: 16.0, color: Colors.grey[400],fontWeight: FontWeight.w800,),
          display3: TextStyle(fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w800,),
          display4: TextStyle(fontSize: 16.0, color: Colors.blueAccent,fontWeight: FontWeight.w800,),
        )
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) =>  StoreScreen(),
        '/orderComplete': (BuildContext context) =>  OrderCompleteScreen(),
      },
    );
  }
}
