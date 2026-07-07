import 'package:flutter/material.dart';

enum GeoShape { circle, square, rectangle, triangle, pentagon, hexagon, trapezoid, rhombus, oval }

class ShapeIntro {
  final GeoShape shape;
  final String name;
  final Color color;
  final String funFact;

  const ShapeIntro(this.shape, this.name, this.color, this.funFact);
}