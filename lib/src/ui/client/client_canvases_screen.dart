import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../../router/router_state.dart';
import '../_widgets/client_canvas.dart';
import '../_widgets/content_constraints.dart';

class ClientCanvasesScreen extends StatelessWidget {
  const ClientCanvasesScreen({required this.clientModel, super.key});

  final ClientModel clientModel;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => clientModel,
        child: Scaffold(
          appBar: AppBar(title: const Text('Client Canvases')),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final canvas = clientModel.canvases.lastOrNull;

              if (canvas == null) {
                context.read<RouterState>().selectedCanvasId = 0;
              } else {
                context.read<RouterState>().selectedCanvasId = canvas.id + 1;
              }
            },
            child: const Icon(Icons.add_rounded),
          ),
          body: const SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 16),
            child: DesktopConstraints(
              child: _Canvases(),
            ),
          ),
        ),
      );
}

class _Canvases extends StatelessWidget {
  const _Canvases();

  @override
  Widget build(BuildContext context) {
    final clientModel = context.watch<ClientModel>();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: clientModel.canvases.length,
      itemBuilder: (context, index) {
        final canvas = clientModel.canvases[index];

        return InkWell(
          onTap: () {
            context.read<RouterState>().selectedCanvasId = canvas.id;
          },
          child: ClientCanvas(canvasId: canvas.id),
        );
      },
    );
  }
}
