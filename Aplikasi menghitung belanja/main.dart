import 'package:aplikasi_hitung_belanja/tabel.dart';
import 'package:aplikasi_hitung_belanja/Home.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Tabel([]),
      child: MaterialApp(
        home: Login(),
      ),
    );
  }
}

// ignore: must_be_immutable
class Login extends StatelessWidget {
  final minimumPadding = 5.0;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  User user;

  Future<User> signInWithGoogle() async {
    await Firebase.initializeApp();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    user = authResult.user;

    return user;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Aplikasi Hitung Belanja"),
        ),
        body: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                top: minimumPadding * 55,
                bottom: minimumPadding * 5,
              ),
              child: Column(
                children: <Widget>[
                  Text(
                    "Selamat Datang di Aplikasi Hitung Belanja",
                    style: TextStyle(fontSize: 17),
                  ),
                  RaisedButton(
                    child: Text("Login dengan Google"),
                    onPressed: () => signInWithGoogle().then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return Home(user,googleSignIn);
                            },
                          ),
                        );
                    }).catchError((e) => print(e.toString())),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
