import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stego_image/converter.dart';
import 'package:stego_image/selectimage.dart';
import 'package:stego_image/theme_constants.dart';

enum Screenmode { encode, decode }

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  Screenmode _screenmode = Screenmode.encode;
  final _textController = TextEditingController();
  Uint8List? _image;
  String _hiddenMessage = '';
  late String path;

  @override
  void initState() {
   // _setPath();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // void _setPath() async {
  //   Directory _path = await getApplicationDocumentsDirectory();
  //   String _localPath = _path.path + Platform.pathSeparator + 'Download';
  //   final savedDir = Directory(_localPath);
  //   bool hasExisted = await savedDir.exists();
  //   if (!hasExisted) {
  //     savedDir.create();
  //   }
  //   path = _localPath;
  // }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  // Future<void> initPlatformState() async {
  //   _setPath();
  //   if (!mounted) return;
  // }
  // bool loading=false;
  // Future<bool> saveFile(String url, String filename) async{
  //   Directory directory;
  //   try{
  //     if(Platform.isAndroid){
  //     }
  //   }catch(e){
  //   }
  //   return true;
  // }
  // downloadFile()async {
  //   setState(() {
  //     loading=true;
  //   });
  // bool downloaded=await saveFile();
  // if(downloaded){
  //   print("File Downloaded");
  // }
  // else{
  //   print("Problem downloading file");
  // }
  //   setState(() {
  //     loading=false;
  //   });
  // }
  // Future<List<Directory>> _getExternalStoragePath() {
  //   return getExternalStorageDirectories(type: StorageDirectory.documents);
  // }
  // // String _fileFullPath;
  // Future _writeExternalStorage(Uint8List bytes) async {
  //   final dirList = await _getExternalStoragePath();
  //   final path = dirList[0].path;
  //   final file = File('$path/Stegd.png');
  //   file.writeAsBytes(bytes).then((File _file) {});
  // }

  Future<void> onPressedEncode() async {
    Uint8List imgBytes = await stegoEncode(_image!, _textController.text);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Image Encoded"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Encoded image saved successfully."),
              const SizedBox(
                height: 20,
              ),
              Image.memory(imgBytes),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Download"),
              onPressed: () async {
                //downloadFile();
          //       var options = DownloaderUtils(
          //         progressCallback: (current, total) {
          //           final progress = (current / total) * 100;
          //           print('Downloading: $progress');
          //         },
          //         file: File('$path/loremipsum.pdf'),
          //         progress: ProgressImplementation(),
          //         onDone: () {
          //           OpenFile.open('$path/loremipsum.pdf');
          //         },
          //         deleteOnCancel: true,
          //       );
          //       var core = await Flowder.download(
          //    "https://assets.website-files.com/603d0d2db8ec32ba7d44fffe/603d0e327eb2748c8ab1053f_loremipsum.pdf",
          //    options,
          //  );
                // Implement download logic here
                // For simplicity, we'll just print the path
                //print("Downloading image from: $imagePath");
                // Add your download logic here using url_launcher or other packages

                // print("ok till here");
                // Directory? directory = await getExternalStorageDirectory();
                // print(directory);
                // String path = directory!.path + "/output_image_with_text.jpg";
                // File file = File(path);
                // await file.writeAsBytes(imgBytes);
                // print("ok till here");

                //               if (Platform.isAndroid) {
                //   await Process.run('am', ['start', '-a', 'android.intent.action.VIEW', '-d', 'file://$path']);
                // }
                // String url = 'content://$path';
                              // Uri uri = Uri.file(path);
                              // print(uri);
                // await launchUrl(uri);
                //await OpenFile.open(path);
                // await launchUrl(url);
                final dirList = await getExternalStorageDirectories(type: StorageDirectory.documents);
                final path = dirList![0].path;
                print(path);
                final file = File('$path/StegoImage.jpeg');

                file.writeAsBytes(imgBytes).then((File _file) {print(_file);});
                //await OpenFile.open(path);
                setState(() {
                  _screenmode=Screenmode.decode;
                  _image=imgBytes;
                  _hiddenMessage="";
                });
              },
            ),
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    // _screenmode == Screenmode.encode
    //     ? stegoEncode(_image!,_textController as String)
    //     : stegoDecode(_image!);
  }

  Future<void> onPressedDecode() async {
    //String text = await stegoDecode(_image!);
    setState(() {
      //_hiddenMessage = text;
      _screenmode==Screenmode.decode && _textController.text.isEmpty? _textController.text="## Not Endcoded From StegoApp ##":null;
      _hiddenMessage=_textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(gradient: mygradBT),
          ),
          foregroundColor: Colors.white,
          title: Text("Steganography"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  color: Colors.white,
                  child: Stack(alignment: Alignment.center, children: [
                    // ElevatedButton(onPressed: () {}, child: Text("Upload image")),
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: mygradRL,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: _image != null
                          ? Image.memory(_image!)
                          : const Center(
                              child: Text(
                                "Upload your image here",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                    ),

                    _image == null
                        ? Positioned(
                            bottom: 5,
                            left: 80,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Container(),
                  ])),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: _screenmode == Screenmode.encode
                    ? TextField(
                        minLines: 1,
                        maxLines: 100,
                        controller: _textController,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: "Enter the text to encode",
                            suffixIcon: IconButton(
                              onPressed: () {
                                _textController.clear();
                              },
                              icon: const Icon(Icons.clear),
                            )),
                      )
                    : Text(_hiddenMessage),
              ),
              // MaterialButton(
              //   onPressed: () {},
              //   color: const Color.fromARGB(255, 174, 85, 190),
              //   child: Text("Post"),
              // ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                  ),
                ),
                onPressed: () {
                  _screenmode == Screenmode.encode
                      ? onPressedEncode()
                      : onPressedDecode();
                },
                child: _screenmode == Screenmode.encode
                    ? Text("Encode")
                    : Text("Decode"),
              )
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(gradient: mygradBT),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: GNav(
                onTabChange: (value) {
                  if (value == 0) {
                    setState(() {
                      _screenmode = Screenmode.encode;
                      _image = null;
                      _textController.clear();
                    });
                  } else {
                    setState(() {
                      _screenmode = Screenmode.decode;
                      _image = null;
                      _textController.clear();
                    });
                  }
                  print(value);
                },
                color: Colors.white,
                activeColor: Colors.white,
                gap: 5,
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
        ));
  }
}
