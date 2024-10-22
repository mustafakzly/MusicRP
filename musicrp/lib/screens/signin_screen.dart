import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:musicrp/screens/home_screen.dart';
import 'package:musicrp/screens/reset_password.dart';
import 'package:musicrp/screens/signup_screen.dart';
import 'package:musicrp/reusable_widgets/reusable_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        return user;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/background1.jpg"), // Arka plan resminin yolunu buraya ekleyin
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget("assets/images/logo.png"),
                  const SizedBox(
                    height: 10,
                  ),
                  relusableTextField("Email Giriniz.", Icons.mail, false,
                      _emailTextController),
                  const SizedBox(
                    height: 10,
                  ),
                  relusableTextField("Şifrenizi giriniz.", Icons.lock, true,
                      _passwordTextController),
                  const SizedBox(
                    height: 10,
                  ),
                  forgetPassword(context),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text,
                        )
                            .then((value) {
                          Fluttertoast.showToast(
                            msg: "Giriş Başarılı",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 2,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        });
                      } on FirebaseAuthException catch (error) {
                        String errorMessage = "";

                        switch (error.code) {
                          case "invalid-email":
                            errorMessage = "Verilen e-posta adresi geçersiz.";
                            break;
                          case "user-disabled":
                           errorMessage = "Kullanıcı hesabı devre dışı bırakıldı.";
                            break;
                          case "invalid-email":
                            errorMessage = "E-posta adresi yanlış biçimlendirilmiş.";
                            break;
                          case "wrong-password":
                            errorMessage = "Şifre geçersiz.";
                            break;
                          case "INVALID_LOGIN_CREDENTIALS":
                            errorMessage = "Giriş kimlik bilgileri geçersiz.";
                            // Burada gerekli işlemleri yapabilirsiniz
                            break;
                          default:
                            errorMessage = "Bir hata oluştu: ${error.code}";
                            // Diğer hata durumları için gerekli işlemleri yapabilirsiniz
                            break;
                        }
                        Fluttertoast.showToast(
                          msg: errorMessage,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 255, 0, 0),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black38;
                        }
                        return Colors.white;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final User? user = await _signInWithGoogle();
                      if (user != null) {
                        Fluttertoast.showToast(
                          msg: "Google ile giriş başarılı.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 17, 255, 0),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Google ile giriş başarısız.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Color.fromARGB(255, 255, 0, 0),
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black38;
                        }
                        return Colors.white;
                      }),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 32),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Google ile Giriş Yap ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  signUpOption(),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Hesabınız yok mu?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: const Text(
            " Kayıt Ol",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Şifremi unuttum!",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }
}
