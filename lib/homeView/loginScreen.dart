import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngebus/crud/admin/readTiketData.dart';
import 'package:ngebus/crud/user/DaftarTiket.dart';
import 'package:ngebus/model/api.dart';
import 'registerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final formHolder = TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _isHidePassword = true;

  removeValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<void> login() async {
    var url = Uri.parse(BaseUrl.login);
    var response = await http.post(
      url,
      body: {
        "username": username.text,
        "password": password.text,
      },
    );

    var data = json.decode(response.body.toString());

    if (data == "Admin") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isAdminLogin", true);
      pref.setString("Admin_Username", username.value.text);
      Fluttertoast.showToast(
          msg: "Login sukses",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadTiketData()),
      );
    } else if (data == "User") {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isUserLogin", true);
      pref.setString("User_Username", username.value.text);
      Fluttertoast.showToast(
          msg: "Login sukses",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DaftarTiket()),
      );
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool("isAdminLogin", false);
      pref.setBool("isUserLogin", false);
      Fluttertoast.showToast(
          msg: "Username and Password salah",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _validateLogin() {
    if (_formKey.currentState.validate()) {
      removeValues();
      print("Validated");
      login();
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

  void _togglePasswordView() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void clearTextInput() {
    formHolder.clear();
  }

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  // ignore: missing_return
  Future cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isAdminLogin") == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReadTiketData()),
      );
    } else if (pref.getBool("isUserLogin") == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DaftarTiket()),
      );
    }
  }

  // ignore: missing_return
  Future<bool> onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Konfirmasi"),
        content: Text("Anda yakin untuk keluar aplikasi?"),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            child: Text("Tidak"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          // ignore: deprecated_member_use
          FlatButton(
            child: Text("Ya"),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Halaman Login',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: username,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: password,
                    obscureText: _isHidePassword,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      hintText: 'Password',
                      suffixIcon: InkWell(
                        onTap: _togglePasswordView,
                        child: Icon(
                          _isHidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  child: ElevatedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      clearTextInput();
                      _validateLogin();
                    },
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text('Tidak punya akun?'),
                      // ignore: deprecated_member_use
                      FlatButton(
                        textColor: Colors.blue,
                        child: Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => RegisterScreen(),
                          ),
                        ),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
