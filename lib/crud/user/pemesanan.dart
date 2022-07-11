import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:ngebus/crud/user/buktiTransaksi.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pemesanan extends StatefulWidget {
  final List list;
  final int index;

  Pemesanan({this.list, this.index});
  @override
  State<StatefulWidget> createState() => new _State();
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              ScaleTransition(
            scale: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              ),
            ),
            child: child,
          ),
        );
}

class _State extends State<Pemesanan> {
  File image;
  final picker = ImagePicker();
  final money = NumberFormat("#,##0", "en_US");
  static String username = "";
  String noTeleponData = "";

  double _height;
  double _width;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static TextEditingController namapenumpang = TextEditingController();
  static TextEditingController notelepon = TextEditingController();
  TextEditingController armada;
  TextEditingController rute;
  TextEditingController waktu;
  TextEditingController tanggal;
  TextEditingController stok;
  TextEditingController tarif;
  TextEditingController nominalpembayaran = TextEditingController();
  TextEditingController kembalian = TextEditingController();

  void updateStok() {
    var url = Uri.parse(BaseUrl.updateStok);
    http.post(
      url,
      body: {
        "id_tiket": widget.list[widget.index]['id_tiket'],
        "stok": stok.text,
      },
    );
  }

  Future<void> orders() async {
    var url = Uri.parse(BaseUrl.pemesanan);
    final response = await http.post(
      url,
      body: {
        "nama_penumpang": namapenumpang.text,
        "no_telepon": notelepon.text,
        "armada": armada.text,
        "rute": rute.text,
        "tanggal": tanggal.text,
        "waktu": waktu.text,
        "tarif": tarif.text,
        "nominal_pembayaran": nominalpembayaran.text,
        "jumlah_kembalian": kembalian.text,
      },
    );

    var data = json.decode(response.body.toString());

    if (data == "Success") {
      Fluttertoast.showToast(
          msg: "Pemesanan berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Pemesanan gagal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void updateUI() {
    setState(() {
      Pemesanan();
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
      var url = Uri.parse(BaseUrl.readNoTelepon);
      final response = await http.post(
        url,
        body: {
          "username": username,
        },
      );
      setState(() {});
      var data = json.decode(response.body.toString());
      notelepon.text = data[0]['no_telepon'];
    }
  }

  void _validateOrders() {
    if (_formKey.currentState.validate()) {
      print("Validated");
      int i = int.parse(stok.text);
      int j = (i - 1);
      setState(() {
        stok.text = j.toString();
      });

      orders();
      updateStok();
      setState(() {
        Navigator.pushReplacement(
          context,
          ScaleRoute(
            page: BuktiTransaksi(),
          ),
        );
      });
    } else {
      print("Not Validated");
      Fluttertoast.showToast(
          msg: "Mohon periksa kembali form anda!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  void initState() {
    setState(() {
      cekLogin();
      cekUser();
    });
    namapenumpang.text = username;
    armada = new TextEditingController(
      text: widget.list[widget.index]['armada'],
    );
    rute = new TextEditingController(
      text:
          "${widget.list[widget.index]['keberangkatan']} - ${widget.list[widget.index]['tujuan']}",
    );
    stok = new TextEditingController(
      text: widget.list[widget.index]['stok'],
    );
    tanggal = new TextEditingController(
      text: widget.list[widget.index]['tanggal'],
    );
    waktu = new TextEditingController(
      text: widget.list[widget.index]['waktu'],
    );
    tarif = new TextEditingController(
      text: widget.list[widget.index]['tarif'],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    namapenumpang.text = username;
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
          width: _width,
          height: _height,
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Pemesanan',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: namapenumpang,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Nama Penumpang',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: notelepon,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.phone),
                      hintText: 'No Telepon',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: armada,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.directions_bus),
                      hintText: 'Armada',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: rute,
                    readOnly: true,
                    showCursor: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.map),
                      hintText: 'Rute',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: tanggal,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'Tanggal',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    readOnly: true,
                    showCursor: false,
                    controller: waktu,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.watch),
                      hintText: 'Waktu',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: tarif,
                    readOnly: true,
                    showCursor: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: 'Tarif',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: nominalpembayaran,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.money),
                      hintText: 'Nominal Pembayaran',
                    ),
                    inputFormatters: [
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (nominalpembayaran) {
                      int a = int.parse(tarif.text);
                      int b = int.parse(nominalpembayaran);
                      int c = (b - a);
                      if (c < 0) {
                        c = 0;
                        setState(() {
                          kembalian.text = c.toString();
                        });
                      } else {
                        setState(() {
                          kembalian.text = c.toString();
                        });
                      }
                    },
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: kembalian,
                    readOnly: true,
                    showCursor: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.calculate),
                      hintText: 'Jumlah Kembalian',
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(0, 30, 40, 30),
                      child: ElevatedButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: ElevatedButton(
                        child: Text(
                          'Pesan',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12), // <-- Radius
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _validateOrders();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
