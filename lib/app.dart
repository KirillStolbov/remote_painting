import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/router/configuration.dart';
import 'src/router/delegate.dart';

class App extends StatelessWidget {
  const App({super.key});

  static final _configuration = AppConfiguration();
  static final _delegate = AppRouterDelegate(_configuration);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _configuration,
        child: MaterialApp.router(
          title: 'Remote Painter',
          routerDelegate: _delegate,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(colorSchemeSeed: Colors.blue),
        ),
      );
}
