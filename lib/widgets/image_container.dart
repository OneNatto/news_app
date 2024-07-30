// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ImageContainer extends StatelessWidget {
  final double width;
  final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final BoxFit? boxFit;

  const ImageContainer({
    Key? key,
    required this.width,
    this.height = 125,
    required this.imageUrl,
    this.padding,
    this.margin,
    this.child,
    this.borderRadius,
    this.boxFit = BoxFit.fill,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        image: DecorationImage(
            image: NetworkImage(imageUrl),
            //fit
            fit: boxFit,
            alignment: Alignment.topCenter),
        color: Colors.grey,
      ),
      child: child,
    );
  }
}
