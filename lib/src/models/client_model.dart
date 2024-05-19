import 'dart:io';

import 'package:flutter/services.dart';

import '../utils/offset_codec.dart';
import 'stream_model.dart';

final class ClientModel extends StreamModel<Socket, Uint8List> {
  ClientModel({required super.stream});

  final relativeOffsets = <Offset?>[];

  @override
  String get info => '${stream.remoteAddress.address}:${stream.remotePort}';

  void addData(Offset? relative) {
    stream.add(OffsetCodec.encode(relative));
    relativeOffsets.add(relative);
    notifyListeners();
  }

  @override
  void onData(Uint8List data) {
    relativeOffsets.add(OffsetCodec.decode(data));
    notifyListeners();
  }

  @override
  Future<void> onDone() async {
    await stream.flush();
    await stream.close();
    stream.destroy();
    super.onDone();
  }
}
