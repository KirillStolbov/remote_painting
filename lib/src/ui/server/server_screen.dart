import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/server_model.dart';
import '../_widgets/client_canvas.dart';

class ServerScreen extends StatelessWidget {
  const ServerScreen(this.model, {super.key});

  final ServerModel model;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => model,
        child: const Scaffold(
          appBar: _AppBar(),
          body: SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 16),
            child: _Clients(),
          ),
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
    final model = context.read<ServerModel>();

    return AppBar(
      title: SelectableText(
        'Server live at: ${model.address}',
        style: style,
      ),
    );
  }
}

class _Clients extends StatelessWidget {
  const _Clients();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ServerModel>();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 0.9,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: model.clients.length,
      itemBuilder: (context, index) {
        final client = model.clients[index];

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //
            Text('Client: ${client.address}'),

            Expanded(
              child: ClientCanvas(
                model: model.clients[index],
              ),
            ),
          ],
        );
      },
    );
  }
}
