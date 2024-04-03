import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen(this.model, {super.key});

  final ClientModel model;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => model,
        child: Scaffold(
          appBar: const _AppBar(),
          body: SafeArea(child: ClientCanvas(model: model)),
        ),
      );
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge;
    final model = context.read<ClientModel>();

    return AppBar(
      title: SelectableText(
        'Connected to: ${model.address}',
        style: style,
      ),
    );
  }
}
