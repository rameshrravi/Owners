import 'package:flutter/material.dart';

class GradientContainer extends StatelessWidget {
  const GradientContainer({
    required this.colors,
    this.stops = const [0.0, 1.0],
    this.child,
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);

  final List<Color> colors;
  final List<double> stops;
  final Widget? child;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? null,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: colors,
        ),
      ),
      child: child,
    );
  }
}
