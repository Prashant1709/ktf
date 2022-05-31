import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  String College="";
  int pno=0;
  String course="";
  DateTime dob=DateTime.now();
  DateTime gy=DateTime.now();
  String address="";
  int pincode=0;
  String uid="";
  String state = "Select State";
  String dropdownValue1 = "Select Gender";
    @override
    double h(double height) {
      return MediaQuery.of(context).size.height * height;
    }

    double w(double width) {
      return MediaQuery.of(context).size.width * width;
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
                            showDialog(barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Select Graduation Year"),
                                  content: Container( // Need to use container to add size constraint.
                                    width: 300,
                                    height: 300,
                                    child: YearPicker(
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(DateTime.now().year + 100, 1),
                                      initialDate: DateTime.now(),
                                      // save the selected date to _selectedDate DateTime variable.
                                      // It's used to set the previous selected date when
                                      // re-showing the dialog.
                                      selectedDate: gy,
                                      onChanged: (DateTime dateTime) {
                                        // close the dialog when year is selected.
                                        Navigator.pop(context);

                                        // Do something with the dateTime selected.
                                        // Remember that you need to use dateTime.year to get the year
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
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
                                  print(dob);
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
                                border: InputBorder.none,
                                hintText: "Course enrolled in",
                                hintStyle: TextStyle(color: Colors.white)),
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
                                border: InputBorder.none,
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.white)),
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
                                border: InputBorder.none,
                                hintText: "State",
                                hintStyle: TextStyle(color: Colors.white)),
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
                                border: InputBorder.none,
                                hintText: "PinCode",
                                hintStyle: TextStyle(color: Colors.white)),
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
                          MaterialButton(onPressed: (){},color: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),child: Text("Submit",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),)

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
