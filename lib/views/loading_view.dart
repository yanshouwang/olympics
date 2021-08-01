import 'dart:math';

import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    final duration = Duration(seconds: 1);
    controller = AnimationController(vsync: this, duration: duration);
    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final radians = controller.value * 2 * pi;
        final size = 60.0;
        return Center(
          child: Transform(
            transform: Matrix4.rotationY(radians),
            origin: Offset(size / 2.0, size / 2.0),
            child: Image.asset(
              'images/tokyo2020.png',
              width: size,
              height: size,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
