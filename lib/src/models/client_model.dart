import 'dart:io';

import 'package:flutter/services.dart';

import '../utils/offset_codec.dart';
import 'socket_model.dart';

final class ClientModel extends SocketModel<Socket, Uint8List> {
  ClientModel(super.socket);

  final relativeOffsets = <Offset?>[];


  void add(Offset? relative) {
    socket.add(OffsetCodec.encode(relative));
    relativeOffsets.add(relative);
    notifyListeners();
  }

  @override
  String get address => '${socket.remoteAddress.address}:${socket.remotePort}';

  @override
  void onData(Uint8List data) {
    relativeOffsets.add(OffsetCodec.decode(data));
    notifyListeners();
  }

  @override
  Future<void> onClose() async {
    await socket.flush();
    await socket.close();
    socket.destroy();
    await super.onClose();
  }
}
