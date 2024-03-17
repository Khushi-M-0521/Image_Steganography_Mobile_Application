import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stego_image/selectimage.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final _textController = TextEditingController();
  Uint8List? _image;
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 130, 84, 138),
        title: Text("Steganography"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Colors.white,
            child: Stack(alignment: Alignment.center, children: [
              // ElevatedButton(onPressed: () {}, child: Text("Upload image")),
              _image != null
                  ? Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2)),
                      child: Image.memory(_image!),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2)),
                      width: 200,
                      height: 200,
                      // color: Colors.white,
                      child: Center(
                        child: Text(
                          "Upload your image here",
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
              Positioned(
                child: IconButton(
                    onPressed: selectImage, icon: Icon(Icons.add_a_photo)),
                bottom: -10,
                left: 80,
              ),
            ]),
          ),
          TextField(
            minLines: 1,
            maxLines: 100,
            controller: _textController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter the text to encode",
                suffixIcon: IconButton(
                  onPressed: () {
                    _textController.clear();
                  },
                  icon: Icon(Icons.clear),
                )),
          ),
          MaterialButton(
            onPressed: () {},
            color: const Color.fromARGB(255, 174, 85, 190),
            child: Text("Post"),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Encode/Decode"))
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              gap: 8,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.enhanced_encryption_outlined,
                  text: "Encode",
                ),
                GButton(
                  icon: Icons.feed_outlined,
                  text: "Decode",
                )
              ]),
        ),
      ),
    );
  }
}
