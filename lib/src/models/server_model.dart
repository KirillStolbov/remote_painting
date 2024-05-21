import 'dart:io';

import 'client_model.dart';
import 'stream_model.dart';

final class ServerModel extends StreamModel<ServerSocket, Socket> {
  ServerModel({required super.stream});

  final clients = <ClientModel>[];

  @override
  String get info => '${stream.address.address}:${stream.port}';

  @override
  void onData(Socket data) {
    // final old = clients.indexWhere(test);

    // if (old != null) {
    //   old.initialize(data);

    //   return;
    // }

    final client = ClientModel(stream: data);

    _addClient(client);
  }

  @override
  void onDone() {
    final clients = List.of(this.clients);

    for (final client in clients) {
      // ignore: discarded_futures
      client.onDone();
    }
    // ignore: discarded_futures
    stream.close();
    super.onDone();
  }

  void _addClient(ClientModel client) {
    clients.add(client);
    notifyListeners();
  }

  // void _removeClient(ClientModel client) {
  //   clients.remove(client);
  //   notifyListeners();
  // }
}
