import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/command.dart';
import '../../models/client_model.dart';
import '../_widgets/client_canvas.dart';

class ClientCanvasScreen extends StatefulWidget {
  const ClientCanvasScreen({
    required this.clientModel,
    required this.canvasId,
    super.key,
  });

  final int canvasId;
  final ClientModel clientModel;

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
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: widget.clientModel,
        child: Scaffold(
          appBar: AppBar(title: const Text('Client Canvas')),
          endDrawerEnableOpenDragGesture: true,
          endDrawer: Drawer(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                //
                Text(
                  'Menu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                IconButton(
                  onPressed: () => widget.clientModel.addCommand(
                    UndoCommand(canvasId: widget.canvasId),
                  ),
                  icon: const Icon(Icons.undo_rounded),
                ),
                IconButton(
                  onPressed: () => widget.clientModel.addCommand(
                    RedoCommand(canvasId: widget.canvasId),
                  ),
                  icon: const Icon(Icons.redo_rounded),
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: ClientCanvas(
              localDrawCommand: _localDrawCommand,
              canvasId: widget.canvasId,
            ),
          ),
        ),
      );
}
