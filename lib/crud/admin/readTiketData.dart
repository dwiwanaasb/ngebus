import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ngebus/crud/admin/createTiketData.dart';
import 'package:ngebus/crud/admin/readRiwayatTransaksi.dart';
import 'package:ngebus/crud/admin/readUserData.dart';
import 'package:ngebus/crud/admin/updateTiketData.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadTiketData extends StatefulWidget {
  final List list;
  final int index;

  ReadTiketData({this.index, this.list});
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ReadTiketData> {
  String username = "";
  String searchString = "";
  TextEditingController search = new TextEditingController();
  final money = NumberFormat("#,##0", "en_US");

  void updateUI() {
    setState(() {
      ReadTiketData();
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(
            Icons.add,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CreateTiketData(),
            ),
          ),
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
                title: Text('Manajemen Tiket'),
                onTap: () {
                  setState(
                    () {
                      updateUI();
                    },
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Manajemen User'),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ReadUserData(),
                      ),
                    );
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.checklist),
                title: Text('Riwayat Transaksi'),
                onTap: () {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ReadRiwayatTransaksi(),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: search,
                      decoration: new InputDecoration(
                          hintText: 'Masukkan Nama Bus...',
                          border: InputBorder.none),
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        search.clear();
                        setState(
                          () {
                            searchString = "";
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getTiketData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            String stok = "";
                            int stokTemp;
                            var getStok = list[index]['stok'];
                            stokTemp = int.parse(getStok);

                            if (stokTemp <= 0) {
                              var stokData = "Tiket Habis";
                              stok = stokData;
                            } else {
                              stok = stokTemp.toString();
                            }
                            return list[index]['armada']
                                    .toLowerCase()
                                    .contains(searchString)
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                    child: Card(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Image.network(
                                            "https://ngebuskaltim.000webhostapp.com/uploads/${list[index]['gambar']}",
                                            width: 130.0,
                                            height: 100.0,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(
                                            width: 15.0,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(list[index]['armada'],
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    )),
                                                Text(
                                                    "${list[index]['keberangkatan']} - ${list[index]['tujuan']}",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                                Text(list[index]['tanggal'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                                Text(list[index]['waktu'],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                                Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Stok : ",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        stok,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: stok ==
                                                                  "Tiket Habis"
                                                              ? Colors.red
                                                              : Colors.black,
                                                          fontWeight: stok ==
                                                                  "Tiket Habis"
                                                              ? FontWeight.w700
                                                              : FontWeight
                                                                  .normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                    "Rp " +
                                                        money.format(int.parse(
                                                            list[index]
                                                                ['tarif'])),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.orange,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                              onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          UpdateTiketData(
                                                    list: list,
                                                    index: index,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 15,
                                            ),
                                          ),
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.red,
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                // set up the buttons
                                                // ignore: deprecated_member_use
                                                Widget cancelButton =
                                                    // ignore: deprecated_member_use
                                                    FlatButton(
                                                  child: Text("Tidak"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                );
                                                // ignore: deprecated_member_use
                                                Widget continueButton =
                                                    // ignore: deprecated_member_use
                                                    FlatButton(
                                                  child: Text("Ya"),
                                                  onPressed: () {
                                                    final url = Uri.parse(
                                                        BaseUrl.deleteTiket);
                                                    http.post(
                                                      url,
                                                      body: {
                                                        'id_tiket': list[index]
                                                            ['id_tiket'],
                                                      },
                                                    );
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            ReadTiketData(),
                                                      ),
                                                    );
                                                  },
                                                );

                                                // set up the AlertDialog
                                                AlertDialog alert = AlertDialog(
                                                  title: Text("Konfirmasi"),
                                                  content: Text(
                                                      "Anda yakin menghapus tiket '${list[index]['armada']}'?"),
                                                  actions: [
                                                    cancelButton,
                                                    continueButton,
                                                  ],
                                                );

                                                // show the dialog
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      elevation: 3,
                                    ),
                                  )
                                : Center();
                          },
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
