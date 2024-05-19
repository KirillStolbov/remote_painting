import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/router/router_state.dart';
import 'src/router/router_delegate.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final _routerState = RouterState();
  static final _routerDelegate = AppRouterDelegate(_routerState);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _routerState,
        child: MaterialApp.router(
          title: 'Remote Painting 72',
          routerDelegate: _routerDelegate,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.blue),
        ),
      );
}
