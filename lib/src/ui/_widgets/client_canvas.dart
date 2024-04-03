import 'package:flutter/material.dart';

import '../../models/client_model.dart';
import '../../utils/relative_offset.dart';

class ClientCanvas extends StatelessWidget {
  const ClientCanvas({required this.model, super.key});

  final ClientModel model;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (_, constraints) {
          final size = constraints.biggest;

          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerUp: (event) => model.add(null),
            onPointerMove: (event) => model.add(event.localPosition.toRelative(size)),
            onPointerDown: (event) => model.add(event.localPosition.toRelative(size)),
            child: CustomPaint(painter: _Painter(model), size: size),
          );
        },
      );
}

class _Painter extends CustomPainter {
  const _Painter(this.model) : super(repaint: model);

  final ClientModel model;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF5F5DC));

    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    for (int i = 0; i < model.relativeOffsets.length - 1; i++) {
      final o1 = model.relativeOffsets[i]?.fromRelative(size);
      final o2 = model.relativeOffsets[i + 1]?.fromRelative(size);
      if (o1 != null && o2 != null) canvas.drawLine(o1, o2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
