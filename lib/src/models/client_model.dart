import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../entities/command.dart';
import '../entities/draw_canvas.dart';
import 'stream_model.dart';

final class ClientModel extends StreamModel<Socket, Uint8List> {
  ClientModel({
    required super.stream,
  }) : remoteIp = stream.remoteAddress.address;

  final List<DrawCanvas> canvases = [];

  final String remoteIp;

  @override
  void onData(Uint8List data) {
    final string = String.fromCharCodes(data);

    final json = jsonDecode(string) as Map<String, Object?>;

    switch (json['type']) {
      case 'sync':
        canvases.addAll(
          (json['data'] as List<Object?>).map(
            (json) => DrawCanvas.fromJson(json as Map<String, Object?>),
          ),
        );

      case 'command':
        final command = Command.fromJson(
          json['data'] as Map<String, Object?>,
        );
        _applyCommand(command);
    }

    notifyListeners();
  }

  @override
  void onDone() {
    super.onDone();
    stream.destroy();
  }

  Iterable<DrawCommand>? drawCommandsOf(int canvasId) {
    for (final canvas in canvases) {
      if (canvas.id == canvasId) return canvas.active;
    }
    return null;
  }

  void addCommand(Command command) {
    final string = jsonEncode({
      'type': 'command',
      'data': command,
    });
    stream.write(string);

    _applyCommand(command);
    notifyListeners();
  }

  void syncCanvases() {
    final string = jsonEncode({
      'type': 'sync',
      'data': canvases.map((e) => e.toJson()).toList(),
    });
    stream.write(string);
  }

  void _applyCommand(Command command) {
    final canvas = canvases.elementAtOrNull(command.canvasId);

    if (command is DrawCommand) {
      if (canvas == null) {
        canvases.add(
          DrawCanvas.active(
            id: command.canvasId,
            active: Queue.from([command]),
          ),
        );
      } else {
        canvas.active.add(command);
      }

      return;
    }

    if (canvas == null) return;

    final active = canvas.active;
    final inactive = canvas.inactive;

    if (command is UndoCommand && active.isNotEmpty) {
      inactive.add(active.removeLast());
    }

    if (command is RedoCommand && inactive.isNotEmpty) {
      active.add(inactive.removeLast());
    }
  }
}
