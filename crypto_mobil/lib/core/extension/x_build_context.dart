import 'package:flutter/material.dart';

extension XBuildContext on BuildContext {
  ThemeData get theme => Theme.of(this);
}
