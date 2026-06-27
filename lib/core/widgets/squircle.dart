import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../const/ui/ds_const.dart';

final class Squircle {
  const Squircle({double radius = cR}) : _radius = radius;

  final double _radius;

  static BorderRadiusGeometry only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return RoundedSuperellipseBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    ).borderRadius;
  }

  BorderRadiusGeometry borderRadius() {
    return RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(_radius),
    ).borderRadius;
  }

  ShapeBorder shape({BorderSide side = BorderSide.none}) {
    return RoundedSuperellipseBorder(
      side: side,
      borderRadius: BorderRadius.circular(_radius),
    );
  }

  OutlinedBorder outlinedShape() {
    return RoundedSuperellipseBorder(
      borderRadius: BorderRadius.circular(_radius),
    );
  }

  /// Creates a [ShapeBorder] with custom per-corner radii.
  static ShapeBorder shapeOnly({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
    BorderSide side = BorderSide.none,
  }) {
    return RoundedSuperellipseBorder(
      side: side,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
  }
}
