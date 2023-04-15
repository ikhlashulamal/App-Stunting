// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, file_names, unused_local_variable, deprecated_member_use, non_constant_identifier_names, unused_import, unused_field, import_of_legacy_library_into_null_safe, avoid_print, unnecessary_new, avoid_unnecessary_containers, depend_on_referenced_packages, unnecessary_string_interpolations, unnecessary_brace_in_string_interps, prefer_const_literals_to_create_immutables, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? selectedImage;
  String hasil = '';
  bool visible = false;

  Future getImageGallery() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.gallery);
    selectedImage = File(pickedImage!.path);
    print(selectedImage);
    setState(() {});
  }

  Future getImageCamera() async {
    final pickedImage =
        await ImagePicker().getImage(source: ImageSource.camera);
    selectedImage = File(pickedImage!.path);
    print(selectedImage);
    setState(() {});
  }

  Future uploadImage() async {
    setState(() {
      visible = true;
    });
    final request = http.MultipartRequest(
      "POST",
      Uri.parse('http://192.168.43.170:5000/uploadmobile'),
    );
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('file',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response res = await http.Response.fromStream(response);
      final resJson = jsonDecode(res.body);
      hasil = resJson["respon"];

      setState(() {
        visible = false;
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedImage == null
                ? Text("Please pick a Image upload")
                : Image.file(
                    selectedImage!,
                    width: 250,
                    height: 150,
                  ),
            SizedBox(height: 20),
            SizedBox(
              height: 10,
            ),
            TextButton.icon(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color.fromARGB(255, 255, 0, 0)),
              ),
              onPressed: uploadImage,
              icon: Icon(Icons.upload),
              label: Text(
                "Cek Hasil",
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255), fontSize: 15),
              ),
            ),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: visible,
                child: Container(child: CircularProgressIndicator())),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hasil: ' + '${hasil}',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (_) {
              return Container(
                child: SimpleDialog(
                  title: Text(
                    "From ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      height: 1.5,
                    ),
                  ),
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: SimpleDialogOption(
                          onPressed: getImageCamera,
                          child: Text(
                            "Camera",
                            style: TextStyle(fontSize: 15),
                          ),
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SimpleDialogOption(
                            onPressed: getImageGallery,
                            child: Text(
                              "Gallery",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
