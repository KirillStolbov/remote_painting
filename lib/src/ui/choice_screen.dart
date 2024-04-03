import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/client_model.dart';
import '../models/server_model.dart';
import '../router/configuration.dart';
import '_widgets/snackBar.dart';

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {
  final _bindIPController = TextEditingController(text: kDebugMode ? '172.20.10.6' : null);
  final _serverIPController = TextEditingController(text: kDebugMode ? '172.20.10.6' : null);
  final _serverPortController = TextEditingController();

  Future<void> _onContinueAsServerTap() async {
    final listenIP = _bindIPController.text;

    if (listenIP.isEmpty) return;

    try {
      final socket = await ServerSocket.bind(listenIP, 0);

      if (mounted) context.read<AppConfiguration>().model = ServerModel(socket);
    } on Object catch (e, s) {
      print('$e, $s');
      if (mounted) showSnackBar(context, 'Failed to bind socket');
    }
  }

  Future<void> _onContinueAsClientTap() async {
    final serverIP = _serverIPController.text;
    final serverPort = int.tryParse(_serverPortController.text);

    if (serverIP.isEmpty || serverPort == null) return;

    try {
      // ignore: close_sinks
      final socket = await Socket.connect(serverIP, serverPort);

      if (mounted) context.read<AppConfiguration>().model = ClientModel(socket);
    } on Object catch (e, s) {
      print('$e, $s');
      if (mounted) showSnackBar(context, 'Failed to connect socket');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: ListView(
                  children: [
                    //
                    const SizedBox(height: 20),

                    TextField(
                      controller: _bindIPController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Server bind IP'),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _onContinueAsServerTap,
                      child: const Text('Continue as server'),
                    ),

                    const Divider(height: 60, thickness: 2),

                    TextField(
                      controller: _serverIPController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Server IP'),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _serverPortController,
                      decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Server port'),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _onContinueAsClientTap,
                      child: const Text('Continue as client'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
