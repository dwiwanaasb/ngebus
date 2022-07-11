import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:form_validator/form_validator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ngebus/model/api.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validatePass = ValidationBuilder().minLength(6).maxLength(15).build();
  final formHolder = TextEditingController();
  TextEditingController namalengkap = new TextEditingController();
  TextEditingController notelepon = new TextEditingController();
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  bool _isHidePassword = true;
  bool _isHideCPassword = true;

  Future<void> register() async {
    var url = Uri.parse(BaseUrl.register);
    var response = await http.post(
      url,
      body: {
        "nama_lengkap": namalengkap.text,
        "no_telepon": notelepon.text,
        "username": username.text,
        "password": password.text,
      },
    );

    var data = json.decode(response.body.toString());

    if (data == "Already") {
      Fluttertoast.showToast(
          msg: "User ini telah tersedia",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (data == "Error") {
      Fluttertoast.showToast(
          msg: "User ini telah logout",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Tambah data berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void _validateRegister() {
    if (_formKey.currentState.validate()) {
      print("Validated");
      register();
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

  void _toggleCPasswordView() {
    setState(() {
      _isHideCPassword = !_isHideCPassword;
    });
  }

  void clearTextInput() {
    formHolder.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'Halaman Register',
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
                  validator: RequiredValidator(errorText: "Required"),
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
                padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                child: ElevatedButton(
                  child: Text(
                    'Register',
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
                    _validateRegister();
                  },
                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                textColor: Colors.blue,
                child: Text(
                  'Kembali ke login',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
