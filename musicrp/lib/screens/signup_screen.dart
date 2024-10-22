import 'package:flutter/material.dart';
import 'package:musicrp/reusable_widgets/reusable_widget.dart';
import 'package:musicrp/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Kayıt Ol",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context)
                .pop();
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                relusableTextField("İsim giriniz.", Icons.person, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                relusableTextField(
                    "Email giriniz.", Icons.mail, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                relusableTextField("Şifre giriniz.", Icons.lock, true,
                    _passwordTextController),
                firebaseButton(context, "Sign Up", () async {
                  try {
                    String email = _emailTextController.text;
                    String password = _passwordTextController.text;
                    var existingUser = await FirebaseAuth.instance
                        .fetchSignInMethodsForEmail(email);

                    if (existingUser.isNotEmpty) {
                      print('Bu e-posta adresi zaten kullanılıyor.');
                    } else {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      )
                          .then((value) {
                        Fluttertoast.showToast(
                          msg: "Kullanıcı kaydı başarılı.",
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
                                builder: (context) => SignInScreen()));
                      });
                    }
                    FirebaseFirestore.instance
                        .collection("Kullanicilar")
                        .doc(_emailTextController.text)
                        .set({
                      "KullaniciAdi": _userNameTextController.text,
                      "KullaniciEposta": _emailTextController.text,
                      "KullaniciSifre": _passwordTextController.text
                    });
                  } on FirebaseAuthException catch (error) {
                    switch (error.code) {
                      case "email-already-in-use":
                        Fluttertoast.showToast(
                          msg: "Bu e-posta daha önce alınnmış.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        break;
                      case "invalid-email":
                        Fluttertoast.showToast(
                          msg: "Geçersiz e-posta adresi girdiniz.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        break;
                      case "weak-password":
                        Fluttertoast.showToast(
                          msg: "Şifreniz 6 karakterden uzun olmalıdır.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        break;
                    }
                    print('Hata: ${error.code}');
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
