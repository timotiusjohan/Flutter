import 'package:aplikasi_hitung_belanja/tabel.dart';
import 'package:aplikasi_hitung_belanja/tabelBarang.dart';
import 'package:aplikasi_hitung_belanja/history.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Home extends StatelessWidget {
  TextEditingController namaC = TextEditingController();
  TextEditingController hargaC = TextEditingController();
  TextEditingController jumlahC = TextEditingController();

  final minimumPadding = 5.0;

  GoogleSignIn googleSignIn;
  User currentUser;

  Home(User _user, GoogleSignIn userLogin){
    this.googleSignIn = userLogin;
    this.currentUser = _user;
  }

  Future<void> signOutGoogle() async {

    await googleSignIn.signOut();

    print("User Signed Out");
  }

  @override
  Widget build(BuildContext context) {
    final tabel = Provider.of<Tabel>(context);
    return Scaffold(
        body: ListView(
        children: <Widget>[
        Container(
          margin: EdgeInsets.all(minimumPadding * 2),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding * 10,
                ),
                child: Text(
                  "Aplikasi Hitung Belanja",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding * 10,
                  bottom: minimumPadding,
                ),
                child: TextField(
                  controller: namaC,
                  decoration: InputDecoration(
                    labelText: "Nama Barang",
                    hintText: "Contoh: Indomie Goreng",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding,
                  bottom: minimumPadding,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: hargaC,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Harga",
                            hintText: "Contoh: 2000",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    ),
                    Container(
                      width: minimumPadding * 2,
                    ),
                    Container(
                      width: minimumPadding * 20,
                      child: TextField(
                        controller: jumlahC,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Jumlah",
                            hintText: "Contoh: 4",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding,
                  bottom: minimumPadding,
                ),
                child: RaisedButton(
                  child: Text("Tambah"),
                  onPressed: () {
                    if (namaC.text == null ||
                        jumlahC.text == null ||
                        hargaC.text == null) {
                      print("Gagal masuk");
                    } else {
                      tabel.addToListBarang(namaC.text, int.parse(hargaC.text),
                          int.parse(jumlahC.text));
                      namaC.clear();
                      hargaC.clear();
                      jumlahC.clear();
                    }
                  },
                ),
              ),
              TabelBarang(),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding,
                  bottom: minimumPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Total Belanja: "),
                    Container(
                      width: minimumPadding * 2,
                    ),
                    Text('${tabel.getTotalBelanja()}'),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    top: minimumPadding,
                    bottom: minimumPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text("Clear"),
                        onPressed: () => tabel.clearListBarang(),
                      ),
                      Container(
                        width: minimumPadding * 2,
                      ),
                      RaisedButton(
                        child: Text("Simpan"),
                        onPressed: () => tabel.saveToDatabase(currentUser.email),
                      ),
                      Container(
                        width: minimumPadding * 2,
                      ),
                      RaisedButton(
                        child: Text("Logout"),
                        onPressed: () {
                          signOutGoogle();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                  top: minimumPadding,
                  bottom: minimumPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Riwayat Belanja"),
                      onPressed: (){
                        DateFormat format = DateFormat("yyyy-MM-dd");
                        String formatted = format.format(DateTime.now());
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              tabel.clearListBarang();
                              return History(formatted,currentUser.email);
                            },
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
