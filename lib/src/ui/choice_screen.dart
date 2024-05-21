import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/server_model.dart';
import '../router/router_state.dart';
import '../utils/snackbar.dart';
import '_widgets/content_constraints.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  Future<void> _onServerTap() async {
    try {
      final socket = await ServerSocket.bind(InternetAddress.anyIPv6, 80);

      if (!mounted) return;

      context.read<RouterState>().model = ServerModel(stream: socket);
    } on Object catch (e, s) {
      log('$e, $s');
      if (mounted) showSnackBar(context, 'Failed to bind socket');
    }
  }

  void _onClientTap() {
    context.read<RouterState>().showClient = true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Setup')),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: DesktopConstraints(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //

                Text(
                  'Choose how you want to proceed',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const Divider(height: 50, thickness: 2),

                const SizedBox(height: 30),

                _IconButton(
                  icon: Icons.settings,
                  onPressed: _onServerTap,
                  caption: 'Continue as server',
                ),

                const SizedBox(height: 30),

                _IconButton(
                  icon: Icons.draw_rounded,
                  onPressed: _onClientTap,
                  caption: 'Continue as client',
                ),
              ],
            ),
          ),
        ),
      );
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.onPressed,
    required this.icon,
    required this.caption,
  });

  final void Function() onPressed;
  final IconData icon;
  final String caption;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 48,
        ),
        onPressed: onPressed,
        iconSize: 40,
        icon: Column(
          children: [
            //
            Icon(icon),

            const SizedBox(height: 10),

            Text(caption),
          ],
        ),
      );
}
