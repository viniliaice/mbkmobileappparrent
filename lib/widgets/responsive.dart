import 'package:flutter/material.dart';

const double desktopBreakpoint = 900;
const double tabletBreakpoint = 600;

bool isDesktop(BuildContext context) =>
    MediaQuery.of(context).size.width >= desktopBreakpoint;

bool isTablet(BuildContext context) {
  final w = MediaQuery.of(context).size.width;
  return w >= tabletBreakpoint && w < desktopBreakpoint;
}

bool isMobile(BuildContext context) =>
    MediaQuery.of(context).size.width < tabletBreakpoint;
