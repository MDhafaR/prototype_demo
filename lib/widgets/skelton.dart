import 'package:flutter/material.dart';

class Skelton extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final bool isCircle;

  const Skelton({
    Key? key,
    this.height,
    this.width,
    this.isCircle = false,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCircle
        ? CircleAvatar(backgroundColor: Colors.white, radius: radius ?? 12)
        : Container(
            height: height ?? 16,
            width: width ?? double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(radius ?? 16),
            ),
          );
  }
}
