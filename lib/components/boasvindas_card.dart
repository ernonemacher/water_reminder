import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_cores.dart';

class BoasVindas_Card extends StatelessWidget {
  @override
  final String text;
  final Widget child;

  const BoasVindas_Card({@required this.text, this.child});

  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          // ignore: missing_return
          text,
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(color: ConfigCores.azulFacebook),
        ),
        child,
      ],
    );
  }
}
