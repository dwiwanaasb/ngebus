import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ngebus/crud/user/pemesanan.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailTiket extends StatefulWidget {
  final List list;
  final int index;

  DetailTiket({this.list, this.index});

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<DetailTiket> {
  String username = "";
  static String stok = "";
  int stokTemp;
  final money = NumberFormat("#,##0", "en_US");
  Future<void> getTiketData() async {
    final url = Uri.parse(BaseUrl.readTiket);
    var response = await http.get(url);
    setState(() {});
    return json.decode(response.body);
  }

  void updateUI() {
    setState(() {
      DetailTiket();
    });
  }

  Future cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isUserLogin") == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future cekUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("User_Username") != null) {
      username = pref.getString("User_Username");
      var url = Uri.parse(BaseUrl.readStok);
      final response = await http.post(
        url,
        body: {
          "id_tiket": widget.list[widget.index]['id_tiket'],
        },
      );
      setState(() {});
      var data = json.decode(response.body);
      var getStok = data[0]['stok'];
      stokTemp = int.parse(getStok);

      if (stokTemp <= 0) {
        var stokData = "Tiket Habis";
        stok = stokData;
      } else {
        stok = stokTemp.toString();
      }
    }
  }

  @override
  void initState() {
    cekLogin();
    cekUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: widget.list[widget.index]['id_tiket'],
                    child: Image.network(
                      "https://ngebuskaltim.000webhostapp.com/uploads/${widget.list[widget.index]['gambar']}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ];
          },
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 30,
                right: 10,
                left: 10,
                child: Column(
                  children: <Widget>[
                    Text(widget.list[widget.index]['armada'],
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        "${widget.list[widget.index]['keberangkatan']} - ${widget.list[widget.index]['tujuan']}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                        "Tanggal Keberangkatan: ${widget.list[widget.index]['tanggal']}",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Jam Keberangkatan: ${widget.list[widget.index]['waktu']}",
                        style: TextStyle(
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Stok : ",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            stok,
                            style: TextStyle(
                              fontSize: 18,
                              color: stok == "Tiket Habis"
                                  ? Colors.red
                                  : Colors.black,
                              fontWeight: stok == "Tiket Habis"
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "Rp " +
                            money.format(
                                int.parse(widget.list[widget.index]['tarif'])),
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: ButtonTheme(
                    height: 50,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      onPressed: () {
                        if (stok == "Tiket Habis") {
                          Fluttertoast.showToast(
                              msg: "Tiket Telah Habis",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          setState(() {
                            updateUI();
                          });
                        } else {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => Pemesanan(
                                  list: widget.list,
                                  index: widget.index,
                                ),
                              ),
                            );
                          });
                        }
                      },
                      color: Colors.orange,
                      child: Text(
                        "Pesan",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
