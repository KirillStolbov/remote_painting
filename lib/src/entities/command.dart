import 'dart:typed_data';

import 'package:flutter/material.dart';

sealed class Command {
  const Command({
    required this.type,
    // required this.canvasId,
  });

  // factory Command.fromType(int type) => switch (type) {
  //       1 => const DrawCommand(),
  //       2 => const UndoCommand(),
  //       3 => const RedoCommand(),
  //       _ => throw ArgumentError.value(
  //           type,
  //           'Command.fromType',
  //           'Invalid Command type',
  //         ),
  //     };

  // final int canvasId;
  final int type;
}

abstract base class DrawCommand extends Command {
  DrawCommand({
    required this.color,
    required this.strokeWidth,
  }) : super(type: 1);

  Color color;
  double strokeWidth;

  Iterable<Float64x2> get points;
}

final class UndoCommand extends Command {
  const UndoCommand() : super(type: 2);
}

final class RedoCommand extends Command {
  const RedoCommand() : super(type: 3);
}

final class RemoteDrawCommand extends DrawCommand {
  RemoteDrawCommand({
    required this.points,
    required super.color,
    required super.strokeWidth,
  });

  @override
  Float64x2List points;
}

final class LocalDrawCommand extends DrawCommand with ChangeNotifier {
  LocalDrawCommand({
    required super.color,
    required super.strokeWidth,
  }) : points = [];

  @override
  List<Float64x2> points;

  void addPoint(Float64x2 point) {
    points.add(point);
    notifyListeners();
  }

  RemoteDrawCommand toRemote() => RemoteDrawCommand(
        points: Float64x2List.fromList(points),
        color: color,
        strokeWidth: strokeWidth,
      );
}
