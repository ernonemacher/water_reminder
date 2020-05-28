import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_cores.dart';

class InfoCard extends StatelessWidget {
  @override
  final IconData icon;
  final String text;
  final Color color;

  const InfoCard({@required this.icon, @required this.text, this.color});

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        child: ListTile(
          title: Text(
            text,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.title,
          ),
          trailing: Icon(
            icon,
            color: color != null ? color : ConfigCores.branco50,
            size: 40,
          ),
        ),
        decoration: BoxDecoration(
            color: ConfigCores.branco20,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
