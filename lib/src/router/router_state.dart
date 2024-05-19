import 'package:flutter/material.dart';

import '../models/stream_model.dart';

final class RouterState extends ChangeNotifier {
  bool _showClient = false;
  bool get showClient => _showClient;
  set showClient(bool showClient) {
    if (_showClient == showClient) return;

    _showClient = showClient;
    notifyListeners();
  }

  StreamModel? _model;
  StreamModel? get model => _model;
  set model(StreamModel? model) {
    if (_model == model) return;

    _model = model;
    notifyListeners();

    if (_showClient) {
      _model?.onDoneCallback = () => this.model = null;
    }
  }
}
