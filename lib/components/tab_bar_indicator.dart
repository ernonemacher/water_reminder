import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_cores.dart';

class TabBarIndicator extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final bool active;

  TabBarIndicator({
    @required this.onTap,
    @required this.icon,
    this.active: false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: active ? 1.2 : 1.0,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ConfigCores.branco,
            boxShadow: [
              BoxShadow(
                color: ConfigCores.branco,
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ]
          ),
          child: Icon(
            icon,
            color: active ? ConfigCores.azulEscuro : ConfigCores.azulClaro,
            size: active ? 30 : 25,
          ),
        ),
      ),
    );
  }
}
