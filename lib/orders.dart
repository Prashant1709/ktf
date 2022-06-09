import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}
class Ord{
  final List<dynamic> items;
  final List<Map<String, dynamic>> iob;
  const Ord({
    required this.items,
    required this.iob,
});
  factory Ord.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> temp = [];
    for (var i in json['eventRegistered']) {
      temp.add(i);
    }
    return Ord(
        items: json['eventRegistered'],
        iob: temp,);
  }
}
class _OrdersState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    futureeve = fetchDat();
  }
  late Future<Ord> futureeve;
  Future<Ord> fetchDat() async {
    final String id =
    await FirebaseAuth.instance.currentUser!.getIdToken(false);
    final response = await http.get(
      Uri.parse('https://ktf-backend.herokuapp.com/data/user'),
      headers: <String, String>{
        "Authorization": "Bearer $id",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Ord.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
        title: Text("Your Orders",style: GoogleFonts.sora(color: Colors.white,fontSize: 16),),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text("Events"),
              ),
              Tab(
                child: Text("Merchs"),
              ),
            ],
            indicatorColor: Colors.white,
          ),
      ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: TabBarView(
            children:[
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: FutureBuilder<Ord>(
                      future: futureeve,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          final merchas = snapshot.data!.iob;
                          return ListView.builder(
                              itemCount: merchas.length,
                              itemBuilder: (context, index){
                                return merchas.isNotEmpty?ListTile(
                                  title: Text("${merchas[index]['name']}"),
                                  tileColor: Colors.white,
                                ):Center(child: Text("Nothing to show",style: GoogleFonts.sora(color: Colors.white),));
                              });
                        }
                        else if (snapshot.hasError) {
                          //print('${snapshot.error}');
                          return const Text('Error Connecting to Servers');
                        }// By default, show a loading spinner.
                        return const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: FutureBuilder<Ord>(
                      future: futureeve,
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          final merchas = snapshot.data!.iob;
                          return ListView.builder(
                              itemCount: merchas.length,
                              itemBuilder: (context, index){
                                return merchas.isNotEmpty?ListTile(
                                  title: Text("${merchas[index]['name']}"),
                                  tileColor: Colors.white,
                                ):Center(child: Text("Nothing to show",style: GoogleFonts.sora(color: Colors.white),));
                              });
                        }
                        else if (snapshot.hasError) {
                          //print('${snapshot.error}');
                          return const Text('Error Connecting to Servers');
                        }// By default, show a loading spinner.
                        return const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
