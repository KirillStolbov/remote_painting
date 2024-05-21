import 'package:flutter/material.dart';

import '../../entities/command.dart';
import '../../models/client_model.dart';
import '../../utils/relative_offset.dart';

const canvasColor = Color(0xFFF5F5DC);

class ClientCanvas extends StatefulWidget {
  const ClientCanvas({required this.model, super.key});

  final ClientModel model;

  @override
  State<ClientCanvas> createState() => _ClientCanvasState();
}

class _ClientCanvasState extends State<ClientCanvas> {
  final _localCommand = LocalDrawCommand(
    color: Colors.black,
    strokeWidth: 2,
  );

  @override
  void dispose() {
    _localCommand.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) {
          final size = constraints.biggest;

          return MouseRegion(
            cursor: SystemMouseCursors.precise,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) {
                _localCommand
                  ..color = Colors.black
                  ..strokeWidth = 2
                  ..addPoint(event.localPosition.toRelative(size));
              },
              onPointerMove: (event) {
                _localCommand.addPoint(event.localPosition.toRelative(size));
              },
              onPointerUp: (event) {
                widget.model.addCommand(_localCommand.toRemote());
                _localCommand.points.clear();
              },
              child: CustomPaint(
                painter: _CanvasPainter(
                  clientModel: widget.model,
                  localDrawCommand: _localCommand,
                ),
                size: size,
              ),
            ),
          );
        },
      );
}

class _CanvasPainter extends CustomPainter {
  _CanvasPainter({
    required this.clientModel,
    required this.localDrawCommand,
  }) : super(repaint: Listenable.merge([clientModel, localDrawCommand]));

  final ClientModel clientModel;
  final LocalDrawCommand localDrawCommand;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();

    canvas
      ..clipRect(Offset.zero & size)
      ..drawRect(Offset.zero & size, paint..color = canvasColor);

    for (final command in [...clientModel.drawCommands, localDrawCommand]) {
      paint
        ..color = command.color
        ..strokeWidth = command.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final firstPoint = command.points.firstOrNull;

      if (firstPoint != null) {
        path.moveTo(firstPoint.x * size.width, firstPoint.y * size.height);
      }

      for (final point in command.points) {
        path.lineTo(point.x * size.width, point.y * size.height);
        path.moveTo(point.x * size.width, point.y * size.height);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
