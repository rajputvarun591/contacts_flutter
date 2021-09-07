import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigationRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {

      default : return MaterialPageRoute(builder: (_) => Material(child: Center(child: Text("${settings.name} Invalid Route"))));
    }
  }
}