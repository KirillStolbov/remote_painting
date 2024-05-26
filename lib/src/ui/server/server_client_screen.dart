import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';
import '../_widgets/content_constraints.dart';

class ServerClientScreen extends StatelessWidget {
  const ServerClientScreen(this.clientModel, {super.key});

  final ClientModel clientModel;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: clientModel,
        child: Scaffold(
          appBar: AppBar(title: Text('Client: ${clientModel.remoteIp}')),
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
      itemBuilder: (context, index) => ClientCanvas(
        canvasId: clientModel.canvases[index].id,
      ),
    );
  }
}
