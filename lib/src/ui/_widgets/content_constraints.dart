import 'package:flutter/material.dart';

class ContentConstraints extends StatelessWidget {
  const ContentConstraints({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: child,
        ),
      );
}
