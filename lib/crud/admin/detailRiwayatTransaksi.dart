import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailRiwayatTransaksi extends StatefulWidget {
  final List list;
  final int index;

  DetailRiwayatTransaksi({this.list, this.index});
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<DetailRiwayatTransaksi> {
  final money = NumberFormat("#,##0", "en_US");
  String username = "";

  void updateUI() {
    setState(() {
      DetailRiwayatTransaksi();
    });
  }

  Future cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isAdminLogin") == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("Admin_Username") != null) {
      setState(() {
        username = pref.getString("Admin_Username");
      });
    }
  }

  Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isAdminLogin", false);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    cekLogin();
    cekUser();
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
          actions: <Widget>[],
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(50, 50, 50, 30),
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
                        widget.list[widget.index]['armada'],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.list[widget.index]['rute'],
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
                                widget.list[widget.index]['nama_penumpang'],
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
                                widget.list[widget.index]['no_telepon'],
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
                                widget.list[widget.index]['tanggal'],
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
                                widget.list[widget.index]['waktu'],
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
                                      int.parse(
                                          widget.list[widget.index]['tarif']),
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
                                      int.parse(widget.list[widget.index]
                                          ['nominal_pembayaran']),
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
                                      int.parse(widget.list[widget.index]
                                          ['jumlah_kembalian']),
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
