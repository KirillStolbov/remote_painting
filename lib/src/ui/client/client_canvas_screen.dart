import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';

class ClientCanvasScreen extends StatelessWidget {
  const ClientCanvasScreen(this.model, {super.key});

  final ClientModel model;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => model,
        child: Scaffold(
          appBar: AppBar(title: const Text('Client Canvas')),
          body: SafeArea(child: ClientCanvas(model: model)),
        ),
      );
}
