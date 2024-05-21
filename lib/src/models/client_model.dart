import 'dart:collection';
import 'dart:io';

import 'package:flutter/services.dart';

import '../entities/command.dart';
import 'stream_model.dart';

final class ClientModel extends StreamModel<Socket, Uint8List> {
  ClientModel({required super.stream});

  final _activeDrawCommands = Queue<DrawCommand>();
  final _inactiveDrawCommands = Queue<DrawCommand>();

  Iterable<DrawCommand> get drawCommands => _activeDrawCommands;

  @override
  String get info => '${stream.remoteAddress.address}:${stream.remotePort}';

  @override
  void onData(Uint8List data) {
    // relativeOffsets.add(OffsetCodec.decode(data));
    // _applyCommand(command);
    // notifyListeners();
  }

  @override
  Future<void> onDone() async {
    await stream.flush();
    await stream.close();
    stream.destroy();
    super.onDone();
  }

  void addCommand(Command command) {
    // stream.add(OffsetCodec.encode(relative));
    _applyCommand(command);
    notifyListeners();
  }

  void _applyCommand(Command command) {
    switch (command) {
      case DrawCommand():
        _activeDrawCommands.add(command);
      case UndoCommand():
        _inactiveDrawCommands.addLast(_activeDrawCommands.removeLast());
      case RedoCommand():
        _activeDrawCommands.addLast(_inactiveDrawCommands.removeLast());
    }
  }
}
