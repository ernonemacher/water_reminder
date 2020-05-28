import 'package:flutter/material.dart';
import 'package:waterreminder/components/app_background.dart';
import 'package:waterreminder/config/config_cores.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Center(child: Text("home")),
        ),
      ),
    );
  }
}
