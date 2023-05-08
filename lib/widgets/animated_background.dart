import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({
    Key? key,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.black,
  }) : super(key: key);

  final Color primaryColor;
  final Color secondaryColor;

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> {
  double radius = 0.5;
  bool isExpanded = false;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 5), toogleRadius);
    super.initState();
  }

  void toogleRadius(timer) {
    if (isExpanded) {
      setState(() => radius = 0.5);
      setState(() => isExpanded = false);
      return;
    }

    setState(() => radius = 0.75);
    setState(() => isExpanded = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 5),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: radius,
          colors: [
            widget.primaryColor,
            widget.secondaryColor,
          ],
        ),
      ),
    );
  }
}
