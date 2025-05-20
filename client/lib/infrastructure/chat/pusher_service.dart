import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PusherService {
  static final PusherService _instance = PusherService._internal();
  factory PusherService() => _instance;

  late PusherChannelsFlutter _pusher;
  final String _appKey = "de556e28253cb2fe6728";
  final String _appSecret = "05453b75f77b02d99b54"; // Sua chave secreta do .env

  PusherService._internal();

  Future<void> initPusher(String chatSessionId, String userId) async {
    _pusher = PusherChannelsFlutter.getInstance();

    await _pusher.init(
      apiKey: _appKey,
      cluster: "us2",
      onAuthorizer: (channelName, socketId, _) => _buildAuthData(
        'private-chat.$chatSessionId',
        socketId,
        userId,
      ),
    );

    await _pusher.subscribe(
      channelName: "private-chat.$chatSessionId",
    );

    _pusher.onEvent = (event) {
      if (event.eventName == "MessageSent") {
        print("Nova mensagem: ${event.data}");
        // Atualize sua UI aqui
      }
    };

    await _pusher.connect();
  }

  Map<String, dynamic> _buildAuthData(
      String channelName, String socketId, String userId) {
    // 2. Formate o channel_data como JSON string COM ASPAS DUPLAS
    final channelData = '{"user_id":"$userId"}'; // Notação exata

    final authString = '$socketId:$channelName:$channelData';

    // 4. Calcule o HMAC-SHA256
    final hmac = Hmac(sha256, utf8.encode(_appSecret));
    final signature = hmac.convert(utf8.encode(authString)).toString();

    // 5. Retorne no formato EXATO que o Pusher espera
    return {
      'auth': '$_appKey:$signature',
      'socket_id': socketId,
      'channel_data': channelData,
    };
  }

  Future<void> disconnect() async {
    await _pusher.disconnect();
  }
}
