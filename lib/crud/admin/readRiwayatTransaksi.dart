import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ngebus/crud/admin/detailRiwayatTransaksi.dart';
import 'package:ngebus/crud/admin/readTiketData.dart';
import 'package:ngebus/crud/admin/readUserData.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReadRiwayatTransaksi extends StatefulWidget {
  final List list;
  final int index;

  ReadRiwayatTransaksi({this.index, this.list});
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

class _State extends State<ReadRiwayatTransaksi> {
  String username = "";
  String searchString = "";
  TextEditingController search = new TextEditingController();
  final money = NumberFormat("#,##0", "en_US");

  void updateUI() {
    setState(() {
      ReadRiwayatTransaksi();
    });
  }

  Future<void> getRiwayatTransaksi() async {
    var url = Uri.parse(BaseUrl.readRiwayatTransaksi);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => ReadTiketData(),
                        ),
                      );
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
                          hintText: 'Masukkan Username...',
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
                future: getRiwayatTransaksi(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            return list[index]['nama_penumpang']
                                    .toLowerCase()
                                    .contains(searchString)
                                ? Column(
                                    children: <Widget>[
                                      Divider(
                                        height: 15,
                                      ),
                                      ListTile(
                                        leading: TextButton(
                                          child: Text(
                                            list[index]['id_order'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                          onPressed: null,
                                        ),
                                        title:
                                            Text(list[index]['nama_penumpang']),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              list[index]['tanggal'],
                                            ),
                                            Text(
                                              list[index]['waktu'],
                                            ),
                                          ],
                                        ),
                                        trailing: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.green,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () => Navigator.push(
                                                  context,
                                                  ScaleRoute(
                                                    page:
                                                        DetailRiwayatTransaksi(
                                                      list: list,
                                                      index: index,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                left: 20,
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
                                                        BaseUrl
                                                            .deleteRiwayatTransaksi,
                                                      );
                                                      http.post(
                                                        url,
                                                        body: {
                                                          'id_order':
                                                              list[index]
                                                                  ['id_order'],
                                                        },
                                                      );
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ReadRiwayatTransaksi(),
                                                        ),
                                                      );
                                                    },
                                                  );

                                                  // set up the AlertDialog
                                                  AlertDialog alert =
                                                      AlertDialog(
                                                    title: Text("Konfirmasi"),
                                                    content: Text(
                                                        "Anda yakin menghapus data '${list[index]['nama_penumpang']}'?"),
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
                                          mainAxisSize: MainAxisSize.min,
                                        ),
                                      ),
                                    ],
                                  )
                                : Center();
                          })
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
