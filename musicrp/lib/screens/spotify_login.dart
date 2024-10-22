import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(SpotifyControlApp());
}

class SpotifyControlApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Spotify Açma ve Premium Kontrolü'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final accessToken = await _getToken(); // Erişim belirtecini al
              if (accessToken != null) {
                // Erişim belirteci başarıyla alındı, Spotify'ı aç
                launchSpotify(context);
              } else {
                // Erişim belirteci alınamadı, kullanıcıya bir hata mesajı göster
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Erişim Belirteci Alınamadı'),
                      content: Text('Spotify erişim belirteci alınamadı.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Kapat'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Text('Spotify Aç'),
          ),
        ),
      ),
    );
  }

  Future<String?> _getToken() async {
    final clientId = 'a728ca77505548f6bfc6c3bbec2dfca7'; // Spotify Geliştirici Paneli'nden alınan Client ID
    final clientSecret = '1a63e36fc7474255b7f70f33e4b2f0af'; // Spotify Geliştirici Paneli'nden alınan Client Secret

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      print('Hata Oluştu: ${response.statusCode}');
      return null;
    }
  }

  void launchSpotify(BuildContext context) async {
    final spotifyUri = "spotify:";

    if (!await canLaunch(spotifyUri)) {
      await launch(spotifyUri);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Spotify Uygulaması Bulunamadı'),
            content: Text('Spotify uygulaması cihazınızda yüklü değil.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Kapat'),
              ),
            ],
          );
        },
      );
    }
  }
}
