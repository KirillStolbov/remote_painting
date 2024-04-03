import 'package:flutter/material.dart';

import '../models/client_model.dart';
import '../models/server_model.dart';
import '../ui/choice_screen.dart';
import '../ui/client/client_screen.dart';
import '../ui/server/server_screen.dart';
import '_pages/material_page.dart';
import 'configuration.dart';

class AppRouterDelegate extends RouterDelegate<AppConfiguration> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  AppRouterDelegate(this._configuration) : _key = GlobalKey() {
    _configuration.addListener(notifyListeners);
  }

  final GlobalKey<NavigatorState> _key;

  final AppConfiguration _configuration;

  @override
  void dispose() {
    _configuration.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  @override
  Widget build(BuildContext context) {
    final model = _configuration.model;

    return Navigator(
      key: _key,
      onPopPage: _onPopPage,
      clipBehavior: Clip.none,
      pages: <Page<void>>[
        //
        asMaterialPage(const ChoiceScreen(), 'ChoiceScreen'),

        if (model is ServerModel) asMaterialPage(ServerScreen(model), 'ServerScreen'),

        if (model is ClientModel) asMaterialPage(ClientScreen(model), 'ServerScreen'),
      ],
    );
  }

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (route.didPop(result)) return _tryPopRoute();

    return false;
  }

  bool _tryPopRoute() {
    if (_configuration.model != null) {
      _configuration.model = null;
      return true;
    }

    return false;
  }

  @override
  Future<void> setNewRoutePath(AppConfiguration configuration) async {}
}
