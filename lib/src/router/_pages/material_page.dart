
import 'package:flutter/material.dart';

Page<void> asMaterialPage(Widget w, String name) => MaterialPage(
      name: name,
      key: ValueKey(name),
      child: Material(
        type: MaterialType.transparency,
        child: w,
      ),
    );
