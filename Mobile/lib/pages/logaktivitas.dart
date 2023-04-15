import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as myhttp;
import 'package:http/http.dart' as http;

class Log extends StatefulWidget {
  const Log({Key? key}) : super(key: key);

  @override
  State<Log> createState() => _HomePageState();
}

class _HomePageState extends State<Log> {
  List _item = [];

  @override
  void initState() {
    super.initState();
    _getData("http://192.168.43.170:5000/logmobile");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Aktivitas"),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _item.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                title: Text(
                  '${_item[index]['Tanggal']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${_item[index]['Aktivitas']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }
            // children: [
            //   Text(
            //     "Tanggal : $tanggal",
            //     style: const TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            //   Text(
            //     "Aktivitas : $aktivitas",
            //     style: const TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            ),
        // ElevatedButton(
        //     onPressed: () async {
        //       // ignore: unused_local_variable
        //       var myresponse = await myhttp
        //           .get(Uri.parse("http://127.0.0.1:5000/logmobile"));
        //       // List<dynamic> body = json.decode(myresponse.body);
        //       // _item = body.map((e) => _HomePageState(
        //       //   tanggal: e['tanggal'],
        //       //   aktivitas: e['aktivitas']
        //       // )).toList;
        //       print("BERHASIL GET DATA");
        //     },
        //     child: Text("Log Aktivitas"),
        //   ),
      ),
    );
  }

  Future _getData(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _item = json.decode(response.body);
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
