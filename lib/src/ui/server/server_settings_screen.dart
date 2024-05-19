import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/server_model.dart';
import '../_widgets/client_canvas.dart';

class ServerSettingsScreen extends StatelessWidget {
  const ServerSettingsScreen(this.model, {super.key});

  final ServerModel model;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => model,
        child: Scaffold(
          appBar: AppBar(title: const Text('Server Settings')),
          body: const SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 16),
            child: _Clients(),
          ),
        ),
      );
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
            Text('Client: ${client.info}'),

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
