import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ktf/home.dart';
class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String College="";
  String pno="";
  String course="";
  DateTime dob=DateTime.now();
  DateTime gy=DateTime.now();
  DateTime sy=DateTime.now();
  String address="";
  String pincode="";
  String uid="";
  String state = "";
  String dropdownValue1 = "Select Gender";
    @override
    double h(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double w(double width) {
      return MediaQuery.of(context).size.width * width;
    }
  Future<bool> createUser() async{
    final String id= await FirebaseAuth.instance.currentUser!.getIdToken(false);
    //final String ui=FirebaseAuth.instance.currentUser!.uid;
    final response=await http.post(
      Uri.parse('https://ktf-backend.herokuapp.com/auth/user-data'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
      body: jsonEncode(<String, dynamic>{
      "college": College.toString(),
      "phoneNumber": int.parse(pno.toString()),
      "graduationYear": int.parse(gy.year.toString()),
      "course": course.toString(),
      "dob": dob.toString(),
      "gender": dropdownValue1.toString(),
      "address": address.toString(),
      "state": state.toString(),
      "pinCode": int.parse(pincode.toString()),
        //"uid": ui.toString(),
      }),

    );
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      print(response.body);
      print(response.statusCode);
      if(response.body.contains("User data updated successfully")){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext bs)=>home()));
      }
      else{
        showDialog(context: context, builder: (BuildContext bs)=>AlertDialog(
          title: Text("The registration failed due to: ${response.body}"),
        ));
      }
      return true;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      print(response.statusCode);
      print(response.body);
      return false;
    }
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.black54,
      content: new Row(
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          Container(margin: EdgeInsets.only(left: 17),child:Text("Loading...",style: GoogleFonts.sora(
            color: Colors.white,

          ), )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: h(1),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: GlassContainer.frostedGlass(
                  height: h(0.8),
                  width: w(0.89),
                  borderRadius: BorderRadius.circular(50),
                  borderColor: Colors.white,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Enter Details",style: GoogleFonts.sora(fontSize: 22,color: Colors.white),),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              icon: Icon(Icons.home,color: Colors.white,),
                                border: InputBorder.none,
                                hintText: "College Name",
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value)=>College=value,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.06,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone number",
                              hintStyle: TextStyle(color: Colors.white),
                              prefixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                            onChanged: (value){
                              pno=value;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(onPressed: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2015, 1, 1),
                                maxTime: DateTime(2035,1,1),
                                theme: DatePickerTheme(
                                    headerColor: Colors.black38,
                                    backgroundColor: Colors.black45,
                                    itemStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle:
                                    TextStyle(color: Colors.white, fontSize: 16)),
                                onChanged: (date) {
                                  //print('change $date');
                                }, onConfirm: (date) {
                                  gy=date;
                                  print(gy);
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },color: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Grad. Year",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),),
                          MaterialButton(onPressed: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(1970, 3, 5),
                                maxTime: DateTime.now(),
                                theme: DatePickerTheme(
                                    headerColor: Colors.black38,
                                    backgroundColor: Colors.black45,
                                    itemStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle:
                                    TextStyle(color: Colors.white, fontSize: 16)),
                                onChanged: (date) {
                                  //print('change $date');
                                }, onConfirm: (date) {
                                  dob=date;
                                  //print(dob);
                                }, currentTime: DateTime.now(), locale: LocaleType.en);
                          },color: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Date of Birth",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),)
                        ],),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              icon: Icon(Icons.book,color: Colors.white,),
                                border: InputBorder.none,
                                hintText: "Course enrolled in",
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value)=>course=value,
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              icon: Icon(Icons.note,color: Colors.white,),
                                border: InputBorder.none,
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value)=>address=value,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            cursorColor: Colors.white,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              icon: Icon(Icons.account_balance,color: Colors.white,),
                                border: InputBorder.none,
                                hintText: "State",
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value)=>state=value,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(5)),
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.only(left: 4),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18, color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              icon: Icon(Icons.pin_drop,color: Colors.white,),
                                border: InputBorder.none,
                                hintText: "PinCode",
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value)=>pincode=value,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [
                          DropdownButton(
                            dropdownColor: Colors.black38,
                            value: dropdownValue1,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            iconSize: 24,
                            elevation: 16,
                            style: const TextStyle(color: Colors.white),
                            underline: Container(
                              height: 2,
                              color: Colors.blueGrey,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue1 = newValue!;
                              });
                            },
                            items: <String>[
                              'Select Gender',
                              'Male',
                              'Female',
                              'Others'
                            ].map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          MaterialButton(onPressed: (){
                            showLoaderDialog(context);
                            createUser();
                          },color: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Submit",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),)

                        ],)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  }
}
