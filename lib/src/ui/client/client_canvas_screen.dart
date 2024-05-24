import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/command.dart';
import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';

class ClientCanvasScreen extends StatefulWidget {
  const ClientCanvasScreen({
    required this.model,
    required this.canvasId,
    super.key,
  });

  final int canvasId;
  final ClientModel model;

  @override
  State<ClientCanvasScreen> createState() => _ClientCanvasScreenState();
}

class _ClientCanvasScreenState extends State<ClientCanvasScreen> {
  late final _localDrawCommand = LocalDrawCommand(
    canvasId: widget.canvasId,
    color: Colors.black,
    strokeWidth: 2,
  );

  @override
  void dispose() {
    _localDrawCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => widget.model,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Client Canvas'),
            actions: [
              IconButton(
                onPressed: () => widget.model.addCommand(
                  RedoCommand(canvasId: widget.canvasId),
                ),
                icon: const Icon(Icons.undo_rounded),
              ),
              IconButton(
                onPressed: () => widget.model.addCommand(
                  UndoCommand(canvasId: widget.canvasId),
                ),
                icon: const Icon(Icons.redo_rounded),
              ),
            ],
          ),
          body: SafeArea(
            child: ClientCanvas(
              model: widget.model,
              localDrawCommand: _localDrawCommand,
            ),
          ),
        ),
      );
}
