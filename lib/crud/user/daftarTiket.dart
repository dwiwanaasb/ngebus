import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ngebus/crud/user/detailTiket.dart';
import 'package:ngebus/crud/user/updateProfile.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarTiket extends StatefulWidget {
  final List list;
  final int index;

  DaftarTiket({this.index, this.list});
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<DaftarTiket> {
  String username = "";
  String searchString = "";
  TextEditingController search = new TextEditingController();
  final money = NumberFormat("#,##0", "en_US");

  void updateUI() {
    setState(() {
      DaftarTiket();
    });
  }

  Future<void> getTiketData() async {
    final url = Uri.parse(BaseUrl.readTiket);
    var response = await http.get(url);
    setState(() {});
    return json.decode(response.body);
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
      setState(() {
        username = pref.getString("User_Username");
      });
    }
  }

  Future logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isUserLogin", false);
    pref.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    cekLogin();
    cekUser();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.person,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(username),
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                // set up the buttons
                // ignore: deprecated_member_use
                Widget cancelButton = FlatButton(
                  child: Text("Tidak"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
                // ignore: deprecated_member_use
                Widget continueButton = FlatButton(
                  child: Text("Ya"),
                  onPressed: () {
                    setState(() {
                      logout();
                    });
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text("Konfirmasi"),
                  content: Text("Anda yakin untuk logout?"),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/background_header.jpg'),
                  ),
                ),
                child: Stack(),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
              ),
              ListTile(
                leading: Icon(Icons.file_copy),
                title: Text('Daftar Tiket'),
                onTap: () {
                  setState(
                    () {
                      updateUI();
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Update Profile'),
                onTap: () {
                  setState(
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => UpdateProfile(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          future: getTiketData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List list = snapshot.data;
                      return Container(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailTiket(
                                    list: list,
                                    index: index,
                                  ),
                                ),
                              );
                            });
                          },
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Hero(
                                  tag: list[index]['id_tiket'],
                                  child: Image.network(
                                    "https://ngebuskaltim.000webhostapp.com/uploads/${list[index]['gambar']}",
                                    fit: BoxFit.fill,
                                    height: 90,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(list[index]['armada'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    )),
                                Text(
                                    "${list[index]['keberangkatan']} - ${list[index]['tujuan']}",
                                    style: TextStyle(
                                      fontSize: 12,
                                    )),
                                //ignore: deprecated_member_use
                                ButtonTheme(
                                  height: 40,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DetailTiket(
                                            list: list,
                                            index: index,
                                          ),
                                        ),
                                      );
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      "Deskripsi",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            elevation: 3,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
