import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../models/server_model.dart';
import '../ui/choice_screen.dart';
import '../ui/client/client_canvas_screen.dart';
import '../ui/client/client_settings_screen.dart';
import '../ui/server/server_settings_screen.dart';
import '_pages/material_page.dart';
import 'router_state.dart';

class AppRouterDelegate extends RouterDelegate<RouterState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  AppRouterDelegate(this._state) : _key = GlobalKey() {
    _state.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _key;

  final RouterState _state;

  @override
  void dispose() {
    _state.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  @override
  Widget build(BuildContext context) {
    final showClient = _state.showClient;
    final model = _state.model;

    return Navigator(
      key: _key,
      onPopPage: _onPopPage,
      clipBehavior: Clip.none,
      pages: <Page<void>>[
        //
        asMaterialPage(const ChoiceScreen(), 'ChoiceScreen'),

        if (model is ServerModel)
          asMaterialPage(ServerSettingsScreen(model), 'ServerSettingsScreen'),

        if (showClient) ...[
          //
          asMaterialPage(const ClientSettingsScreen(), 'ClientSettingsScreen'),

          if (model is ClientModel)
            asMaterialPage(ClientCanvasScreen(model), 'ClientCanvasScreen'),
        ],
      ],
    );
  }

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (route.didPop(result)) return _tryPopRoute();

    return false;
  }

  bool _tryPopRoute() {
    if (_state.model != null) {
      _state.model = null;
      return true;
    }

    if (_state.showClient) {
      _state.showClient = false;
      return true;
    }

    return false;
  }

  @override
  Future<void> setNewRoutePath(RouterState configuration) async {}
}
