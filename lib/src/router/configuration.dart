import 'package:flutter/material.dart';

import '../models/socket_model.dart';

final class AppConfiguration extends ChangeNotifier {
  SocketModel? _model;
  SocketModel? get model => _model;
  set model(SocketModel? model) {
    if (_model == model) return;

    _model = model;
    notifyListeners();

    _model?.onCloseCallback = () {
      _model = null;
      notifyListeners();
    };
  }
}
