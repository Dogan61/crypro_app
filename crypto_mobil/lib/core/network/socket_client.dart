import 'package:crypto_mobil/core/config/api_config.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

@lazySingleton
class SocketClient {
  SocketClient(this._logger);
  io.Socket? _socket;
  final Logger _logger;

  io.Socket get socket {
    if (_socket == null) {
      throw Exception('Socket not connected. Call connect() first.');
    }
    return _socket!;
  }

  bool get isConnected => _socket?.connected ?? false;

  void Function()? _onConnectCallback;

  void connect({void Function()? onConnected}) {
    if (_socket?.connected ?? false) {
      _logger.w('Socket already connected');
      onConnected?.call();
      return;
    }

    _onConnectCallback = onConnected;

    _socket = io.io(
      ApiConfig.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.onConnect((_) {
      _logger.i('Socket.IO connected');
      _onConnectCallback?.call();
    });

    _socket!.onDisconnect((_) {
      _logger.w('Socket.IO disconnected');
    });

    _socket!.onConnectError((data) {
      _logger.e('Socket.IO connection error: $data');
    });

    _socket!.onError((data) {
      _logger.e('Socket.IO error: $data');
    });

    _socket!.connect();
  }

  void disconnect() {
    if (_socket == null) return;

    _logger.i('Socket.IO disconnecting...');
    _socket!.disconnect();
    _socket!.dispose();
    _socket = null;
  }

  void subscribe(List<String> symbols) {
    if (!isConnected) {
      _logger.e('Cannot subscribe: Socket not connected');
      return;
    }

    _logger.i('Subscribing to symbols: $symbols');
    _socket!.emit('subscribe', symbols);
  }

  void unsubscribe(List<String> symbols) {
    if (!isConnected) return;

    _logger.i('Unsubscribing from symbols: $symbols');
    _socket!.emit('unsubscribe', symbols);
  }

  void on(String event, void Function(dynamic) callback) {
    if (!isConnected) {
      _logger.e('Cannot listen to $event: Socket not connected');
      return;
    }
    
    _socket!.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void ping() {
    if (!isConnected) return;
    _socket!.emit('ping');
  }
}
