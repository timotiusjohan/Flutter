import 'package:aplikasi_hitung_belanja/tabel.dart';


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TabelBarang extends StatelessWidget {

  List<Map<String,String>> list;

  final minimumPadding = 5.0;

  @override
  Widget build(BuildContext context) {
    final tabel = Provider.of<Tabel>(context);
    list = tabel.getList();
    return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "Nama Barang",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Harga",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Jumlah",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  "Total",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            rows: list?.map((element) => DataRow(
              cells: <DataCell>[
                DataCell(Text(element["nama barang"])),
                DataCell(Text(element["harga"])),
                DataCell(Text(element["jumlah"])),
                DataCell(Text(element["total"])),
              ],
            ))?.toList() ?? [],
          ),
    );

  }
}
