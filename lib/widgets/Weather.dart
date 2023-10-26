import 'package:flutter/material.dart';

class Weather extends StatelessWidget {
  const Weather({super.key, required this.temperature2M});
  final double temperature2M;
  @override
  Widget build(BuildContext context) =>  Center(
          child: Text(
            "$temperature2M°",
            style:
                const TextStyle(fontSize: 80, fontWeight: FontWeight.w400),
          ),
        );
}
