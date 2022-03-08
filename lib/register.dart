import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vaccine/Firebase.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

Color colors = Color(0xFF4267B2);
String select; // gender value storace

//circular indicator

bool circular = false;

// image picker

File _imageFile;
final ImagePicker _picker = ImagePicker();
// controller
TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController phoneNumber = TextEditingController();

class _CreateProfileState extends State<CreateProfile> {
  // handle validation

  final _globalKey = GlobalKey<FormState>();

  FirebaseRegister firebaseRegister = new FirebaseRegister();
  // Gender radio button function

  Row addRadioButton(String btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: colors,
          value: btnValue.toString(),
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              select = value;
            });
          },
        ),
        Text(title)
      ],
    );
  }

  // Date of birth function

  DateTime _date = DateTime.now();

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));

    if (picked != null && picked != _date) {
      print(_date.toString());

      setState(() {
        _date = picked;
        print(_date.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            emailTextField(),
            SizedBox(
              height: 20,
            ),
            addressTextField(),
            SizedBox(
              height: 20,
            ),
            phoneTextField(),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                addRadioButton("male", 'Male'),
                addRadioButton("female", 'Female'),
                addRadioButton("others", 'Others'),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            dateOfBirthTextField(),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalKey.currentState.validate()) {
                  if (_imageFile != null) {
                    firebaseRegister.onPressed();
                    firebaseRegister.uploadPic(context, _imageFile);
                    Navigator.pop(context);
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => Home()));
                    setState(() {
                      circular = false;
                    });
                  } else {
                    firebaseRegister.onPressed();
                    setState(() {
                      circular = false;
                    });
                  }
                } else {
                  setState(() {
                    circular = false;
                  });
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xFF4267B2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/profile.jpg")
                : FileImage(File(_imageFile.path)),
          ),
          Positioned(
            bottom: 0,
            right: 15,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomSheet()));
              },
              child: Icon(
                Icons.camera_alt,
                color: colors,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallary"),
              )
            ],
          )
        ],
      ),
    );
  }

  // image picking method

  void takePhoto(ImageSource source) async {
    // ignore: deprecated_member_use
    final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      controller: name,
      validator: (value) {
        if (value.isEmpty) return "Name can't be empty";
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: colors)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2.0)),
          prefixIcon: Icon(
            Icons.person,
            color: Color(0xFF4267B2),
          ),
          labelText: "Full Name",
          helperText: "Names can't be empty",
          hintText: "Add here"),
    );
  }

  Widget phoneTextField() {
    return TextFormField(
        //enabled: false,
        controller: phoneNumber,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide(color: colors)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2.0)),
            prefixIcon: Icon(
              Icons.phone,
              color: Color(0xFF4267B2),
            ),
            hintText: "Phone Number"));
  }

  Widget emailTextField() {
    return TextFormField(
      controller: email,
      validator: (value) {
        if (value.isEmpty) return "Email can't be empty";
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: colors)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2.0)),
          prefixIcon: Icon(
            Icons.email,
            color: Color(0xFF4267B2),
          ),
          labelText: "Email",
          helperText: "Email can be empty",
          hintText: "Add here"),
    );
  }

  Widget addressTextField() {
    return TextFormField(
      controller: address,
      validator: (value) {
        if (value.isEmpty) return "Address can't be empty";
        return null;
      },
      decoration: InputDecoration(
          border: OutlineInputBorder(borderSide: BorderSide(color: colors)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.orange, width: 2.0)),
          prefixIcon: Icon(
            Icons.map,
            color: Color(0xFF4267B2),
          ),
          labelText: "Address",
          helperText: "Address can be empty",
          hintText: "Add here"),
    );
  }

  Widget dateOfBirthTextField() {
    return InkWell(
      onTap: () {
        selectDate(context);
      },
      child: Container(
        height: 60,
        child: Row(
          children: [
            Icon(
              Icons.date_range,
              color: Color(0xFF4267B2),
              size: 30,
            ),
            SizedBox(
              width: 15,
            ),
            Text(_date.toString()),
          ],
        ),
        decoration: BoxDecoration(
            border: Border.all(color: colors),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
