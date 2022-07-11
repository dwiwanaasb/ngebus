import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngebus/crud/user/daftarTiket.dart';
import 'package:ngebus/homeView/loginScreen.dart';
import 'package:ngebus/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatefulWidget {
  final List list;
  final int index;

  UpdateProfile({this.list, this.index});

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<UpdateProfile> {
  static String username = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validatePass = ValidationBuilder().minLength(6).maxLength(15).build();
  static TextEditingController namalengkap = new TextEditingController();
  static TextEditingController notelepon = new TextEditingController();
  static TextEditingController usernameData = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmpass = new TextEditingController();
  bool _isHidePassword = true;
  bool _isHideCPassword = true;
  bool updateMode = false;

  updateUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("isUserLogin", true);
    pref.setString("User_Username", username);
  }

  removeValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void update() {
    var url = Uri.parse(BaseUrl.updateProfile);
    http.post(
      url,
      body: {
        "nama_lengkap": namalengkap.text,
        "no_telepon": notelepon.text,
        "username": username,
        "password": password.text,
      },
    );
  }

  void _validateUpdate() {
    if (_formKey.currentState.validate()) {
      print("Validated");
      update();
      removeValues();
      setState(() {
        updateUser();
      });

      Fluttertoast.showToast(
        msg: "Update Data Sukses",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => DaftarTiket(),
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
        fontSize: 16.0,
      );
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }

  void _toggleCPasswordView() {
    setState(() {
      _isHideCPassword = !_isHideCPassword;
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
      var url = Uri.parse(BaseUrl.readUpdateProfile);
      final response = await http.post(
        url,
        body: {
          "username": username,
        },
      );
      setState(() {});
      var data = json.decode(response.body.toString());
      namalengkap.text = data[0]['nama_lengkap'];
      notelepon.text = data[0]['no_telepon'];
      usernameData.text = username;
    }
  }

  @override
  void initState() {
    setState(() {
      cekLogin();
      cekUser();
    });
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
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Ngebus v1.0"),
        ),
        body: Center(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    'Ubah Data',
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
                    controller: namalengkap,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.account_box),
                      hintText: 'Nama Lengkap',
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
                    validator: RequiredValidator(
                        errorText: "Masukkan no telepon anda"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: usernameData,
                    readOnly: true,
                    showCursor: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Username',
                    ),
                    validator: RequiredValidator(
                        errorText: "Username tidak dapat diubah"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    obscureText: _isHidePassword,
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
                    validator: MultiValidator([
                      RequiredValidator(errorText: "Wajib diisi"),
                      MinLengthValidator(6,
                          errorText: "Password minimal 6 karakter"),
                      MaxLengthValidator(15,
                          errorText: "Password maksimal 15 karakter")
                    ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: confirmpass,
                    keyboardType: TextInputType.text,
                    obscureText: _isHideCPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.check_box),
                      hintText: 'Confirm Password',
                      suffixIcon: InkWell(
                        onTap: _toggleCPasswordView,
                        child: Icon(
                          _isHideCPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Masukkan kembali password anda';
                      }
                      print(password.text);
                      print(confirmpass.text);

                      if (password.text != confirmpass.text) {
                        return "Password tidak sesuai";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(120, 30, 120, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: ElevatedButton(
                    child: Text(
                      'Update',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _validateUpdate();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
