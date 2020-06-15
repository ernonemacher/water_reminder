import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:waterreminder/components/water_icon.dart';
import 'package:waterreminder/config/config_cores.dart';

class WaterSlider extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final int divisions;
  final Function onChanged;

  WaterSlider(
      {this.value,
      @required this.min,
      @required this.max,
      @required this.divisions,
      @required this.onChanged});

  @override
  _WaterSliderState createState() => _WaterSliderState();
}

class _WaterSliderState extends State<WaterSlider> {
  int value;

  @override
  void initState() {
    super.initState();

    value = widget.value ?? widget.min;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: <Widget>[
              WaterIcon(),
              Text(
                "${this.value.toStringAsFixed(0)} ml",
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: ConfigCores.azulEscuro,
                    ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: Slider(
            max: widget.max.toDouble(),
            min: widget.min.toDouble(),
            divisions: widget.divisions,
            value: this.value.toDouble(),
            onChanged: (vl) {
              setState(() {
                this.value = vl.toInt();
              });
              EasyDebounce.debounce("onChangeSlider",
                  Duration(milliseconds: 500), _callOnChanged);
            },
          ),
        ),
      ],
    );
  }

  void _callOnChanged() {
    print("VALOR ALTERADO $value");
    widget.onChanged(value);
  }
}
