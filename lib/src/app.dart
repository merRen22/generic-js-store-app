import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_store_app/src/UI/orderCompleteScreen.dart';
import 'package:generic_store_app/src/UI/storeScreen.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
    
    final HttpLink httpLink = HttpLink(uri: 'http://test-server-merren22.herokuapp.com/api');

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(
          dataIdFromObject: typenameDataIdFromObject,
        ),
      ),
    );

    super.build(context);
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryIconTheme: IconThemeData(color: Color(0xff333333)),
        accentIconTheme: IconThemeData(color: Color(0xff0500FF)),
        iconTheme: IconThemeData(color: Color(0xffFF8000)),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        fontFamily: "Open Sans",
        primaryColor: Colors.black,
        primaryTextTheme: TextTheme(
          title: TextStyle(fontSize: 24.0, color: Colors.black),
          subtitle: TextStyle(fontSize: 28.0, color: Colors.black),
          body1: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
          body2: TextStyle(fontSize: 14.0, color: Colors.grey[800],fontWeight: FontWeight.w800),
          display1: TextStyle(fontSize: 14.0, color: Color(0xffFF2D55),fontWeight: FontWeight.w800),
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
    ));
  }
}
