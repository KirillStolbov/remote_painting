import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../entities/command.dart';
import '../entities/draw_commands.dart';
import 'stream_model.dart';

final class ClientModel extends StreamModel<Socket, Uint8List> {
  ClientModel({required super.stream});

  final Map<int, DrawCommands> _canvases = {};

  Iterable<DrawCommand>? drawCommandsOf(int? canvasId) =>
      _canvases[canvasId]?.active;

  @override
  String get info => '${stream.remoteAddress.address}:${stream.remotePort}';

  @override
  void onData(Uint8List data) {
    final string = String.fromCharCodes(data);
    final command =
        Command.fromJson(jsonDecode(string) as Map<String, Object?>);
    _applyCommand(command);
    notifyListeners();
  }

  @override
  Future<void> onDone() async {
    await stream.flush();
    await stream.close();
    stream.destroy();
    super.onDone();
  }

  void addCommand(Command command) {
    final string = jsonEncode(command);
    stream.write(string);
    _applyCommand(command);
    notifyListeners();
  }

  void _applyCommand(Command command) {
    if (command is DrawCommand) {
      final active = _canvases[command.canvasId]?.active;

      if (active != null) {
        active.add(command);
      } else {
        _canvases[command.canvasId] = DrawCommands(
          active: Queue.from([command]),
          inactive: Queue(),
        );
      }

      return;
    }

    final active = _canvases[command.canvasId]?.active;
    final inactive = _canvases[command.canvasId]?.inactive;

    if (active == null || inactive == null) return;

    if (command is UndoCommand && active.isNotEmpty) {
      inactive.add(active.removeLast());

      return;
    }

    if (command is RedoCommand && inactive.isNotEmpty) {
      active.add(inactive.removeLast());

      return;
    }
  }
}
