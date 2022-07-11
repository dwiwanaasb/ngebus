import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ngebus/crud/admin/readTiketData.dart';
import 'package:ngebus/custom/currency.dart';
import 'package:ngebus/model/api.dart';

class UpdateTiketData extends StatefulWidget {
  final List list;
  final int index;

  UpdateTiketData({this.list, this.index});

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<UpdateTiketData> {
  File image;
  final picker = ImagePicker();

  double _height;
  double _width;
  String setTime, setDate;
  String _hour, _minute, _time;
  String dateTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController armada;
  TextEditingController keberangkatan;
  TextEditingController tujuan;
  TextEditingController waktu;
  TextEditingController tanggal;
  TextEditingController stok;
  TextEditingController tarif;
  TextEditingController gambar;

  update() async {
    final url = Uri.parse(BaseUrl.updateTiket);
    var request = http.MultipartRequest('POST', url);
    request.fields['id_tiket'] = widget.list[widget.index]['id_tiket'];
    request.fields['armada'] = armada.text;
    request.fields['keberangkatan'] = keberangkatan.text;
    request.fields['tujuan'] = tujuan.text;
    request.fields['waktu'] = waktu.text;
    request.fields['tanggal'] = tanggal.text;
    request.fields['stok'] = stok.text;
    request.fields['tarif'] = tarif.text.replaceAll(",", "");
    var pic = await http.MultipartFile.fromPath("gambar", image.path);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Update data berhasil",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Update data gagal",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1999),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        tanggal.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        waktu.text = _time;
        waktu.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

  void updateUI() {
    setState(() {
      UpdateTiketData();
    });
  }

  Future choiceImage() async {
    var pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage.path);
    });
  }

  @override
  void initState() {
    armada = new TextEditingController(
      text: widget.list[widget.index]['armada'],
    );
    keberangkatan = new TextEditingController(
      text: widget.list[widget.index]['keberangkatan'],
    );
    tujuan = new TextEditingController(
      text: widget.list[widget.index]['tujuan'],
    );
    tanggal = new TextEditingController(
      text: widget.list[widget.index]['tanggal'],
    );
    waktu = new TextEditingController(
      text: widget.list[widget.index]['waktu'],
    );
    stok = new TextEditingController(
      text: widget.list[widget.index]['stok'],
    );
    tarif = new TextEditingController(
      text: widget.list[widget.index]['tarif'],
    );

    tanggal.text = DateFormat.yMd().format(DateTime.now());

    waktu.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    super.initState();
  }

  void _validateCreate() {
    if (_formKey.currentState.validate() && image != null) {
      print("Validated");
      setState(() {
        update();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ReadTiketData(),
        ),
      );
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
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    dateTime = DateFormat.yMd().format(DateTime.now());
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ngebus v1.0"),
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
                    'Update Data',
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
                    controller: armada,
                    keyboardType: TextInputType.text,
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
                    controller: keberangkatan,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.location_pin),
                      hintText: 'Keberangkatan',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: tujuan,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.location_pin),
                      hintText: 'Tujuan',
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.expand_more),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
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
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.watch),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.expand_more),
                        onPressed: () {
                          _selectTime(context);
                        },
                      ),
                      hintText: 'Waktu',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: stok,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.add_box),
                      hintText: 'Stok',
                    ),
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: TextFormField(
                    controller: tarif,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      prefixIcon: Icon(Icons.attach_money),
                      hintText: 'Tarif',
                    ),
                    inputFormatters: [
                      // ignore: deprecated_member_use
                      WhitelistingTextInputFormatter.digitsOnly,
                      CurrencyFormat()
                    ],
                    validator: RequiredValidator(errorText: "Wajib diisi"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: image == null
                      ? Image.network(
                          "http://192.168.43.198/ngebus/database/uploads/${widget.list[widget.index]['gambar']}")
                      : Image.file(image),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // ignore: deprecated_member_use
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        onPressed: () {
                          choiceImage();
                        },
                        textColor: Colors.white,
                        color: Colors.blue,
                        padding: EdgeInsets.fromLTRB(5, 8, 5, 8),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                color: Colors.blue,
                                padding: EdgeInsets.fromLTRB(10, 4, 4, 4),
                                child: Text(
                                  'Upload Gambar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 0, 10, 0),
                                child: Icon(
                                  Icons.backup,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  padding: EdgeInsets.fromLTRB(120, 30, 120, 0),
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: ElevatedButton(
                    child: Text(
                      'Submit',
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
                        _validateCreate();
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
