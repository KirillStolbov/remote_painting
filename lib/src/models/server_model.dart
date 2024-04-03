import 'dart:io';

import 'client_model.dart';
import 'socket_model.dart';

final class ServerModel extends SocketModel<ServerSocket, Socket> {
  ServerModel(super.socket);

  final clients = <ClientModel>[];

  @override
  String get address => '${socket.address.address}:${socket.port}';

  void _addClient(ClientModel client) {
    clients.add(client);
    notifyListeners();
  }

  void _removeClient(ClientModel client) {
    clients.remove(client);
    notifyListeners();
  }

  @override
  void onData(Socket data) {
    final client = ClientModel(data);
    _addClient(client);
    client.onCloseCallback = () => _removeClient(client);
  }

  @override
  Future<void> onClose() async {
    final clients = List.of(this.clients);
    for (final client in clients) {
      await client.onClose();
    }
    await socket.close();
    await super.onClose();
  }
}
