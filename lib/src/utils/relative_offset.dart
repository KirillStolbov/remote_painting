import 'package:flutter/material.dart';

extension RelativeOffsetExt on Offset {
  Offset toRelative(Size size) => scale(1 / size.width, 1 / size.height);
  Offset fromRelative(Size size) => scale(size.width, size.height);
}
