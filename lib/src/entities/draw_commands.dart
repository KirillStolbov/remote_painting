import 'dart:collection';

import 'command.dart';

class DrawCommands {
  const DrawCommands({
    required this.active,
    required this.inactive,
  });

  final Queue<DrawCommand> active;
  final Queue<DrawCommand> inactive;
}
