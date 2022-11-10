import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dart_ping/dart_ping.dart';

void main() => runApp(MyApp());
String ip_address = '';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}




class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Applying get request.

  Future getRequest() async {
    String url = "https://api.myip.com";
    final response = await http.get(Uri.parse(url));
    print('before');

    var responseData = json.decode(response.body);


    print(responseData);
    return responseData;
  }

  Future<Map> main() async {
    // Create ping object with desired args
    String ping_address = 'https://google.com';
    final ping = Ping(ip_address, count: 5);
    print('ip_Address  $ip_address');
    print('ping_address  $ping_address');
    // Begin ping process and listen for output
    var response;
    var error;
    ping.stream.listen((event) {
      print(event);
      response = event.response;
      error = event.error;
      print('event.response ${event.response}');
      print('event.error ${event.error}');
    });
    return {'error': error, 'response': response};
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Http Get Request."),
          leading: Icon(
            Icons.get_app,
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: getRequest(),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                ip_address = snapshot.data['ip'];
                print(ip_address);
                return Text(snapshot.data.toString());
              }
            },
          ),
        ),
        floatingActionButton: ElevatedButton(
          child: Text('ping'),
          onPressed: () async {
            var map = await main();
            print(map['error']);
            print(map['response']);
            },
        )   ,
      ),
    );
  }
}
