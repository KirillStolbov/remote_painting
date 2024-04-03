import 'dart:async';

import 'package:flutter/material.dart';

abstract base class SocketModel<S extends Stream<D>, D extends Object?> extends ChangeNotifier {
  SocketModel(this.socket) {
    _subscription = socket.listen(
      onData,
      onDone: onClose,
      onError: (_, __) async => onClose(),
    );
  }

  final S socket;
  String get address;
  late final StreamSubscription<D> _subscription;

  @mustCallSuper
  Future<void> onClose() async => onCloseCallback?.call();
  void Function()? onCloseCallback;
  void onData(D data);

  @override
  Future<void> dispose() async {
    await onClose();
    await _subscription.cancel();
    super.dispose();
  }
}
