import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPlayer(),
    );
  }
}

class MusicPlayer extends StatefulWidget {
  final String? playlistURL;
  final String? categoryName;

  MusicPlayer({Key? key, this.playlistURL, this.categoryName})
      : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final String clientId = 'e3fb31a210a34901ad6e9b407d1c59cc';
  final String clientSecret = '221d7863f1e743949d4f4d9656da960f';
  final String redirectUri = 'http://192.168.1.100:8080/callback';
  final String scope = 'user-read-private user-read-email';
  final String serverUrl = 'http://192.168.1.100:8080/callback';

  List<String> trackNames = [];
  List<String> trackImages = [];
  List<String> artistNames = [];
  int currentIndex = 0;
  bool isPlaying = false;
  String accessToken = '';

  final ScrollController _scrollController = ScrollController();

  List<String> savedTrackNames = [];
  List<String> savedTrackImages = [];
  List<String> savedArtistNames = [];

  static const tokenRefreshInterval = const Duration(minutes: 30);

  DateTime _lastTokenRefreshTime = DateTime.now();

  late String playlistUrl;
  late String? playlist;
  late String? categoryName;

  @override
  void initState() {
    super.initState();
    _getTokenAndFetchData();
    _fetchSpotifyData();
    playlist = widget.playlistURL;
    categoryName = widget.categoryName;
    if (playlist != null) {
      playlistUrl = playlist!;
    } else {
      playlistUrl =
          'https://api.spotify.com/v1/playlists/632pTiuCZmAGveJaJYcM0K/tracks?offset=0&limit=100';
    }
    print('playlistURL from MusicPlayer: $playlistUrl');
    print('categoryName from MusicPlayer: $categoryName');
  }

  Future<void> _getTokenAndFetchData() async {
    try {
      final token = await _getToken();

      setState(() {
        accessToken = token;
      });

      await _fetchSpotifyData();
      _getRandomTracksFromAll();
    } catch (e) {
      print('Hata Oluştu: $e');
    }
  }

  Future<void> _fetchSpotifyData() async {
    try {
      final asd = await http.get(
        Uri.parse(playlistUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (asd.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(asd.body);

        if (data.containsKey('items')) {
          final List<String> allTrackNames = [];
          final List<String> allTrackImages = [];
          final List<String> allArtistNames = [];

          for (var item in data['items']) {
            final track = item['track'];

            if (track != null && track.containsKey('name')) {
              allTrackNames.add(track['name']);
              if (track.containsKey('album') &&
                  track['album'].containsKey('images') &&
                  track['album']['images'].isNotEmpty) {
                allTrackImages.add(track['album']['images'][0]['url']);
              } else {
                allTrackImages.add('DEFAULT_IMAGE_URL');
              }
              if (track.containsKey('artists') && track['artists'].isNotEmpty) {
                allArtistNames.add(track['artists'][0]['name']);
              } else {
                allArtistNames.add('Bilinmeyen Sanatçı');
              }
            }
          }

          setState(() {
            trackNames = allTrackNames;
            trackImages = allTrackImages;
            artistNames = allArtistNames;
            currentIndex = 0;
          });
        } else {
          print('API yanıtında "items" bulunamadı.');
        }
      } else {
        print('Hata Oluştu: ${asd.statusCode}');
      }
    } catch (e) {
      print('Hata Oluştu: $e');
    }
  }

  Future<String> _getToken() async {
    final asd = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );
    print('Erişim Belirteci (Access Token): ${asd.body}');
    if (asd.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(asd.body);
      return data['access_token'];
    } else {
      print('Hata Oluştu: ${asd.statusCode}');
      throw Exception('Failed to get access token');
    }
  }

  Future<String?> _authorizeWithSpotify() async {
    final authorizeUrl = Uri(
      scheme: 'https',
      host: 'accounts.spotify.com',
      path: '/authorize',
      queryParameters: {
        'client_id': clientId,
        'redirect_uri': redirectUri,
        'scope': scope,
        'response_type': 'code',
      },
    );

    if (await canLaunchUrl(authorizeUrl)) {
      await launchUrl(authorizeUrl);
      print('Spotify yetkilendirme sayfası açıldı');
      return await _listenForCodeRedirect();
    } else {
      print('Spotify yetkilendirme sayfasını açarken hata oluştu');
      return null;
    }
  }

  Future<String?> _listenForCodeRedirect() async {
    String? code;
    await uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        if (uri.toString().startsWith(redirectUri)) {
          code = uri.queryParameters['code'];
        }
      }
    });
    print('Code: $code');
    return code;
  }

  Future<String?> _getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization':
            'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['access_token'];
    } else {
      print('Erişim belirteci alınamadı. Hata: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> _checkPremiumStatus(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/me'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final product = data['product'];
      return product == 'premium';
    } else {
      print('Premium statüsü alınamadı. Hata: ${response.statusCode}');
      return false;
    }
  }

  Future<void> _authorizeAndCheckPremiumStatus() async {
    try {
      final code = await _authorizeWithSpotify();
      if (code != null) {
        final accessToken = await _getAccessToken(code);
        if (accessToken != null) {
          final isPremium = await _checkPremiumStatus(accessToken);
          if (isPremium) {
            print('Kullanıcı premium statüsüne sahip');
          } else {
            print('Kullanıcı premium statüsüne sahip değil');
          }
        } else {
          print('Erişim belirteci alınamadı');
        }
      } else {
        print('Code alınamadı');
      }
    } catch (e) {
      print('Hata oluştu: $e');
    }
  }

  void _playPause() {
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _nextTrack() {
    setState(() {
      if (currentIndex < trackNames.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      isPlaying = true;
    });
  }

  void _previousTrack() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = trackNames.length - 1;
      }
      isPlaying = true;
    });
  }

  void _selectTrack(int index) {
    setState(() {
      currentIndex = index;
      isPlaying = true;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _getRandomTracksFromAll() {
    final random = Random();
    final List<int> indices =
        List.generate(trackNames.length, (index) => index);
    indices.shuffle();

    final List<String> randomTrackNames = [];
    final List<String> randomTrackImages = [];
    final List<String> randomArtistNames = [];

    for (var i = 0; i < min(20, trackNames.length); i++) {
      final randomIndex = indices[i];
      randomTrackNames.add(trackNames[randomIndex]);
      randomTrackImages.add(trackImages[randomIndex]);
      randomArtistNames.add(artistNames[randomIndex]);
    }

    setState(() {
      savedTrackNames = randomTrackNames;
      savedTrackImages = randomTrackImages;
      savedArtistNames = randomArtistNames;
      currentIndex = 0;
    });
  }

  Future<void> _playTrack(String trackUri) async {
    try {
      final asd = await http.put(
        Uri.parse('https://api.spotify.com/v1/me/player/play'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'uris': [trackUri],
        }),
      );
      if (asd.statusCode == 204) {
        print('Müzik çalınıyor: $trackUri');
      } else {
        print('Hata Oluştu: ${asd.statusCode}');
      }
    } catch (e) {
      print('Hata Oluştu: $e');
    }
  }

  Future<void> _refreshAccessTokenIfNeeded() async {
    final currentTime = DateTime.now();
    final timeSinceLastRefresh = currentTime.difference(_lastTokenRefreshTime);

    if (timeSinceLastRefresh >= tokenRefreshInterval) {
      try {
        final token = await _getToken();

        setState(() {
          accessToken = token;
          _lastTokenRefreshTime = currentTime;
        });
      } catch (e) {
        print('Hata Oluştu: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _refreshAccessTokenIfNeeded();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Önerilen Müzikler - $categoryName',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/a.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              if (savedTrackImages.isNotEmpty &&
                  currentIndex < savedTrackImages.length)
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    child: Image.network(savedTrackImages[currentIndex]),
                  ),
                ),
              SizedBox(height: 10),
              if (savedTrackNames.isNotEmpty &&
                  currentIndex < savedTrackNames.length)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            50.0),
                    child: Text(
                      savedTrackNames[currentIndex],
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.skip_previous),
                    color: Colors.white,
                    onPressed: _previousTrack,
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    color: Colors.white,
                    onPressed: () async {
                      final currentTrackUri = savedTrackNames.isNotEmpty &&
                              currentIndex < savedTrackNames.length
                          ? savedTrackNames[currentIndex]
                          : 'URI_YOK';

                      if (currentTrackUri != 'URI_YOK') {
                        _playTrack(currentTrackUri);
                        _playPause();
                      }
                    },
                  ),
                  IconButton(
                    iconSize: 30,
                    icon: Icon(Icons.skip_next),
                    color: Colors.white,
                    onPressed: _nextTrack,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await _authorizeAndCheckPremiumStatus();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text('Spotify\'ı Aç ve Premium Kontrol Et'),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(0),
                  itemCount: savedTrackNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                        ),
                        child: Image.network(savedTrackImages[index]),
                      ),
                      title: Text(
                        savedArtistNames[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        savedTrackNames[index],
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        _selectTrack(index);
                        Future.delayed(Duration(milliseconds: 10), () {
                        });
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _getRandomTracksFromAll,
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text('Rastgele 20 Müzik Getir',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
