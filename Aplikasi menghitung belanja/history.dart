import 'package:aplikasi_hitung_belanja/tabelBarang.dart';
import 'package:aplikasi_hitung_belanja/tabel.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  String _currentUser;
  String _selectedDateString;

  History(this._selectedDateString, this._currentUser);

  @override
  _HistoryState createState() =>
      _HistoryState(_selectedDateString, _currentUser);
}

class _HistoryState extends State<History> {
  DateTime selectedDate = DateTime.now();
  String selectedDateString;
  String currentUser;

  final minimumPadding = 5.0;

  _HistoryState(this.selectedDateString, this.currentUser);

  void selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        DateFormat format = DateFormat("yyyy-MM-dd");
        selectedDateString = format.format(selectedDate);
      });
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
                    top: minimumPadding * 20,
                    bottom: minimumPadding * 10,
                  ),
                  child: Text(
                    "Riwayat Belanja",
                    style: TextStyle(
                      fontSize: 25,
                    ),
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
                      Text(
                        "${selectedDateString}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: minimumPadding * 3,
                      ),
                      RaisedButton(
                          child: Text("Pilih Tanggal"),
                          onPressed: () => selectDate(context)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: minimumPadding,
                    bottom: minimumPadding,
                  ),
                  child: RaisedButton(
                    child: Text("Cari Riwayat"),
                    onPressed: () {
                      DateFormat format = DateFormat("yyyy-MM-dd");
                      selectedDateString = format.format(selectedDate);
                      tabel.cariRiwayat(selectedDateString, currentUser);
                    },
                  ),
                ),
                TabelBarang(),
                Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    top: minimumPadding * 2,
                    bottom: minimumPadding * 2,
                  ),
                  child: RaisedButton(
                    child: Text("Kembali"),
                    onPressed: (){
                      Navigator.pop(context);
                      tabel.clearListBarang();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
