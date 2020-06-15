import 'package:flutter/material.dart';
import 'package:waterreminder/config/config_cores.dart';

class InfoCard extends StatelessWidget {
  @override
  final IconData icon;
  final String text;
  final String subtitle;
  final Color color;
  final bool invertido;
  final bool bordaNormal;
  final double verticalPadding;

  const InfoCard({
    @required this.icon,
    @required this.text,
    this.color,
    this.invertido: false,
    this.bordaNormal: true,
    this.verticalPadding: 16,
    this.subtitle,
  });

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
          child: ListTile(
            title: Text(
              text,
              textAlign: _buildTextAlign(),
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: subtitle == null
                ? null
                : Text(
                    subtitle,
                    textAlign: _buildTextAlign(),
                    style: Theme.of(context).textTheme.subhead.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
            trailing: invertido ? null : _buildIcon(),
            leading: invertido ? _buildIcon() : null,
          ),
          decoration: BoxDecoration(
            color: ConfigCores.branco20,
            borderRadius: _buildBorder(),
          ),
        ));
  }

  Widget _buildIcon() {
    return Icon(
      icon,
      color: color != null ? color : ConfigCores.branco50,
      size: 40,
    );
  }

  BorderRadiusGeometry _buildBorder() {
    if (bordaNormal) {
      return BorderRadius.all(
        Radius.circular(10),
      );
    }

    if (invertido) {
      return BorderRadius.only(
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      );
    } else {
      return BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      );
    }
  }

  TextAlign _buildTextAlign() {
    if (invertido) {
      return TextAlign.right;
    } else
      return TextAlign.left;
  }
}
