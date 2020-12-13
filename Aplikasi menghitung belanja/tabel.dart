import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Tabel with ChangeNotifier {
  List<Map<String, String>> listBarang;
  int totalBelanja = 0;

  Tabel(this.listBarang);

  getList() => this.listBarang;

  getTotalBelanja() => this.totalBelanja.toString();

  void addToListBarang(String namaBarang, int hargaBarang, int jumlahBarang) {
    Map<String, String> mapBarang = {
      "tanggal": "",
      "nama barang": "",
      "harga": "",
      "jumlah": "",
      "total": "",
    };
    int total = hargaBarang * jumlahBarang;
    DateTime now = DateTime.now();
    DateFormat format = DateFormat("yyyy-MM-dd");
    String formatted = format.format(now);
    mapBarang.update("tanggal", (value) => formatted);
    mapBarang.update("nama barang", (value) => namaBarang);
    mapBarang.update("harga", (value) => hargaBarang.toString());
    mapBarang.update("jumlah", (value) => jumlahBarang.toString());
    mapBarang.update("total", (value) => total.toString());

    listBarang.add(mapBarang);

    int hitungBelanja = 0;

    listBarang.forEach((element) {
      hitungBelanja += int.parse(element["total"]);
      print(hitungBelanja);
    });

    totalBelanja = hitungBelanja;
    notifyListeners();
  }

  void clearListBarang() {
    totalBelanja = 0;
    listBarang.clear();
    notifyListeners();
  }

  void saveToDatabase(String currentUser) {
    listBarang.forEach((element) {
      FirebaseFirestore.instance.collection("Daftar Belanja").doc().set({
        'User': currentUser,
        'Tanggal': element["tanggal"],
        'Nama Barang': element["nama barang"],
        'Harga': element["harga"],
        'Jumlah': element["jumlah"],
        'Total': element["total"],
      }).then((value) {
        totalBelanja = 0;
        listBarang.clear();
        notifyListeners();
      });
    });
  }

  void cariRiwayat(String selectedDate, String currentUser) {
    clearListBarang();
    FirebaseFirestore.instance
        .collection("Daftar Belanja")
        .where(
          "Tanggal",
          isEqualTo: selectedDate,
        )
        .where(
          "User",
          isEqualTo: currentUser,
        )
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
        addToListBarang(
          element.data()["Nama Barang"],
          int.parse(element.data()["Harga"]),
          int.parse(element.data()["Jumlah"]),
        );
      });
    });
  }
}
