import 'package:flutter/material.dart';

import '../models/stream_model.dart';

final class RouterState extends ChangeNotifier {
  bool _showClientSettings = false;
  bool get showClient => _showClientSettings;
  set showClient(bool showClientSettings) {
    if (_showClientSettings == showClientSettings) return;

    _showClientSettings = showClientSettings;
    notifyListeners();
  }

  StreamModel? _model;
  StreamModel? get model => _model;
  set model(StreamModel? model) {
    _model = model;
    notifyListeners();

    if (_showClientSettings) {
      _model?.onDoneCallback = () => this.model = null;
    }
  }

  int? _selectedCanvasId;
  int? get selectedCanvasId => _selectedCanvasId;
  set selectedCanvasId(int? selectedCanvasId) {
    if (_selectedCanvasId == selectedCanvasId) return;

    _selectedCanvasId = selectedCanvasId;
    notifyListeners();
  }
}
