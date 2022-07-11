import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ngebus/crud/user/daftarTiket.dart';
import 'package:ngebus/model/api.dart';

class BuktiTransaksi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<BuktiTransaksi> {
  final money = NumberFormat("#,##0", "en_US");
  String namapenumpangData = "";
  String noteleponData = "";
  String armadaData = "";
  String ruteData = "";
  String tanggalData = "";
  String waktuData = "";
  String tarifData = "";
  String nominalpembayaranData = "";
  String kembalianData = "";

  void updateUI() {
    setState(() {
      BuktiTransaksi();
    });
  }

  cekData() async {
    var url = Uri.parse(BaseUrl.readBuktiTransaksi);
    final response = await http.get(url);
    setState(() {});
    var data = json.decode(response.body.toString());

    namapenumpangData = data[0]['nama_penumpang'];
    noteleponData = data[0]['no_telepon'];
    armadaData = data[0]['armada'];
    ruteData = data[0]['rute'];
    tanggalData = data[0]['tanggal'];
    waktuData = data[0]['waktu'];
    tarifData = data[0]['tarif'];
    nominalpembayaranData = data[0]['nominal_pembayaran'];
    kembalianData = data[0]['jumlah_kembalian'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DaftarTiket()),
                  );
                });
              },
            )
          ],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(30),
                child: Text(
                  'Bukti Transaksi',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(50, 0, 50, 30),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20.0),
                  children: <Widget>[
                    Center(
                      child: Text(
                        "''" + armadaData + "''",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        ruteData,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(180),
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text(
                                'Nama Penumpang :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                namapenumpangData,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'No Telepon :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                noteleponData,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Tanggal :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                tanggalData,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Waktu :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                waktuData,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Tarif :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rp " +
                                    money.format(
                                      int.parse(tarifData),
                                    ),
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Nominal Pembayaran :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rp " +
                                    money.format(
                                      int.parse(nominalpembayaranData),
                                    ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              Text(
                                'Jumlah Kembalian :',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rp " +
                                    money.format(
                                      int.parse(kembalianData),
                                    ),
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 60,
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.green,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "* Silahkan Capture Data Diatas Sebagai Bukti Transaksi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
