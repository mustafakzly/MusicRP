import 'package:flutter/material.dart';
import 'package:musicrp/screens/signin_screen.dart';
import 'package:musicrp/screens/spotify.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  final List<String> sliderTexts = [
    "Rock",
    "Caz",
    "Klasik",
    "Rap",
    "Soundtrack",
    "Blues",
    "R&B",
    "Progresif",
    "Heavy metal",
    "Kelt",
    "Punk",
    "Pop"
  ];
  String selectedText = "Müzik Türü";

  void previousSlide() {
    setState(() {
      currentIndex = (currentIndex - 1) % sliderTexts.length;
      if (currentIndex < 0) {
        currentIndex = sliderTexts.length - 1;
      }
      selectedText = sliderTexts[currentIndex];
    });
  }

  void nextSlide() {
    setState(() {
      currentIndex = (currentIndex + 1) % sliderTexts.length;
      selectedText = sliderTexts[currentIndex];
    });
  }

  int currentIndex1 = 0;
  final List<String> sliderTexts1 = [
    "Öfke",
    "Korku",
    "Utanç",
    "Tiksinti",
    "Neşe Coşku",
    "Üzüntü",
    "Şaşkınlık"
  ];
  String selectedText1 = "Duygu Durumu";

  void previousSlide1() {
    setState(() {
      currentIndex1 = (currentIndex1 - 1) % sliderTexts1.length;
      if (currentIndex1 < 0) {
        currentIndex1 = sliderTexts1.length - 1;
      }
      selectedText1 = sliderTexts1[currentIndex1];
    });
  }

  void nextSlide1() {
    setState(() {
      currentIndex1 = (currentIndex1 + 1) % sliderTexts1.length;
      selectedText1 = sliderTexts1[currentIndex1];
    });
  }

  int currentIndex2 = 0;
  final List<String> sliderTexts2 = [
    "Karlı",
    "Yağmurlu",
    "Rüzgarlı",
    "Bulutlu",
    "Fırtınalı",
    "Sisli"
  ];
  String selectedText2 = "Hava Durumu";

  void previousSlide2() {
    setState(() {
      currentIndex2 = (currentIndex2 - 1) % sliderTexts2.length;
      if (currentIndex2 < 0) {
        currentIndex2 = sliderTexts2.length - 1;
      }
      selectedText2 = sliderTexts2[currentIndex2];
    });
  }

  void nextSlide2() {
    setState(() {
      currentIndex2 = (currentIndex2 + 1) % sliderTexts2.length;
      selectedText2 = sliderTexts2[currentIndex2];
    });
  }

  Map<String, String> genreURLs = {
    "Rock":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DWXRqgorJj26U/tracks?offset=0&limit=100",
    "Caz":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DXbITWG1ZJKYt/tracks?offset=0&limit=100",
    "Klasik":
        "https://api.spotify.com/v1/playlists/4moiImefasqdAKUuONBAd8/tracks?offset=0&limit=100",
    "Rap":
        "https://api.spotify.com/v1/playlists/6p3IRyXLrl28mu33AHtqnj/tracks?offset=0&limit=100",
    "Soundtrack":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DX1tz6EDao8it/tracks?offset=0&limit=100",
    "Blues":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DXd9rSDyQguIk/tracks?offset=0&limit=100",
    "R&B":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DX2WkIBRaChxW/tracks?offset=0&limit=100",
    "Progresif":
        "https://api.spotify.com/v1/playlists/5CMvAWTlDPdZnkleiTHyyo/tracks?offset=0&limit=100",
    "Heavy metal":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DX9qNs32fujYe/tracks?offset=0&limit=100",
    "Kelt":
        "https://api.spotify.com/v1/playlists/37i9dQZF1E4wFdXRIBf07F/tracks?offset=0&limit=100",
    "Punk":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DXd6tJtr4qeot/tracks?offset=0&limit=100",
    "Pop":
        "https://api.spotify.com/v1/playlists/0JQ5DAqbMKFEC4WFtoNRpw/tracks?offset=0&limit=100"
  };

  Map<String, String> emotionURLs = {
    "Öfke":
        "https://api.spotify.com/v1/playlists/0KPEhXA3O9jHFtpd1Ix5OB/tracks?offset=0&limit=100",
    "Korku":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DZ06evO06fYh1/tracks?offset=0&limit=100",
    "Utanç":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DZ06evO3OqAUQ/tracks?offset=0&limit=100",
    "Tiksinti":
        "https://api.spotify.com/v1/playlists/3qgzMg4m5tvf16PzlPgGa9/tracks?offset=0&limit=100",
    "Neşe Coşku":
        "https://api.spotify.com/v1/playlists/7mjMabinSkJnMihNnB4fSe/tracks?offset=0&limit=100",
    "Üzüntü":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DX7qK8ma5wgG1/tracks?offset=0&limit=100",
    "Şaşkınlık":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DX0Ew6u9sRtTY/tracks?offset=0&limit=100",
  };

  Map<String, String> weatherURLs = {
    "Karlı":
        "https://api.spotify.com/v1/playlists/4WCmHOBqKS7pac4s1lW2ZY/tracks?offset=0&limit=100",
    "Yağmurlu":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DXbvABJXBIyiY/tracks?offset=0&limit=100",
    "Rüzgarlı":
        "https://api.spotify.com/v1/playlists/011ehcZV5brKd9bQSBMzLM/tracks?offset=0&limit=100",
    "Bulutlu":
        "https://api.spotify.com/v1/playlists/37i9dQZF1E4ytWIvGY7bkX/tracks?offset=0&limit=100",
    "Fırtınalı":
        "https://api.spotify.com/v1/playlists/37i9dQZF1DZ06evO3jKKAN/tracks?offset=0&limit=100",
    "Sisli":
        "https://api.spotify.com/v1/playlists/37i9dQZF1E4s4v1v77km4B/tracks?offset=0&limit=100",
  };

  String? getURLForSelectedText(String selectedText) {
    String? selectedURL;

    if (genreURLs.containsKey(selectedText)) {
      selectedURL = genreURLs[selectedText];
    } else if (emotionURLs.containsKey(selectedText1)) {
      selectedURL = emotionURLs[selectedText1];
    } else if (weatherURLs.containsKey(selectedText2)) {
      selectedURL = weatherURLs[selectedText2];
    }

    return selectedURL;
  }

  final ScrollController _scrollController = ScrollController();
void showSelectedText() {
  String? selectedURL;
  String? categoryName; 
  int count = 0;

  if (genreURLs.containsKey(selectedText)) {
    selectedURL = genreURLs[selectedText];
    categoryName = selectedText;
    count++;
  }
  if (emotionURLs.containsKey(selectedText1)) {
    selectedURL = emotionURLs[selectedText1];
    categoryName = selectedText1;
    count++;
  }
  if (weatherURLs.containsKey(selectedText2)) {
    selectedURL = weatherURLs[selectedText2];
    categoryName = selectedText2; 
    count++;
  }

  if (count == 0) {
    Fluttertoast.showToast(
      msg: "Lütfen bir seçim yapınız",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    resetValues();
  } else if (count > 1) {
    Fluttertoast.showToast(
      msg: "Lütfen yalnızca bir seçim yapınız",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    resetValues();
  } else {
    if (selectedURL != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MusicPlayer(playlistURL: selectedURL, categoryName: categoryName),
        ),
      ).then((value) {
        resetValues();
      });
    }
  }
}



void resetValues() {
  setState(() {
    currentIndex = 0;
    selectedText = "Müzik Türü";
    currentIndex1 = 0;
    selectedText1 = "Duygu Durumu";
    currentIndex2 = 0;
    selectedText2 = "Hava Durumu";
  });
}

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Hoşgeldiniz",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(255, 58, 58, 58),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Container(
              child: Image.asset(
                "assets/images/images.png",
                width: 160,
                height: 160,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Uygulamamız sizin durumunuza göre müzik önermektedir. Makine öğrenmesi ile müzik listelerimizi oluşturmaktayız.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousSlide,
                  child: Icon(Icons.arrow_left),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: nextSlide,
                  child: Icon(Icons.arrow_right),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousSlide1,
                  child: Icon(Icons.arrow_left),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedText1,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: nextSlide1,
                  child: Icon(Icons.arrow_right),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: previousSlide2,
                  child: Icon(Icons.arrow_left),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  selectedText2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: nextSlide2,
                  child: Icon(Icons.arrow_right),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: showSelectedText,
              child: Text("Öneri yap"),
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
                textStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
