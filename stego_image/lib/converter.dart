import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

String _AppMark='StegoApp';

List<int> _textToBits(String txt){
  List<int> textBytes = utf8.encode(txt);
  print(textBytes);
  List<int> textBits = [];
  for (int byte in textBytes) {
    for (int i = 0; i < 8; i++) {
      textBits.add((byte >> (7 - i)) & 1);
    }
  }
  print(textBits);
  return textBits;
}

String _bitsToText(List<int> dataBits){
  List<int> dataBytes=[];
  for (int i = 0; i < dataBits.length; i += 8) {
    int byte = 0;
    for (int j = 0; j < 8; j++) {
      byte = (byte << 1) | dataBits[i + j];
    }
    dataBytes.add(byte);
  }
  String txt = utf8.decode(dataBytes);
  return txt;
}

Future<Uint8List> stegoEncode(Uint8List bytes,String textToHide) async {
  print(bytes.sublist(0,100));
  final textBits = _textToBits(textToHide);
  //print(textBits);
  final ownerMark=_textToBits("$_AppMark${textToHide.length}");
  for (int i = 0; i < textBits.length; i++) {
    bytes[i] = (bytes[i] & 0xFE) | textBits[i];
    print("i am ok");
  }
  //print(ownerMark.length);
  for (int i = 0; i < ownerMark.length; i++) {
    bytes[bytes.length - ownerMark.length + i] =
        (bytes[bytes.length - ownerMark.length + i] & 0xFE) | ownerMark[i];
    //print(i);
  }
  // for (int i = ownerMark.length -1; i>=0 ; i--){
  //   bytes[bytes.length-i]=(bytes[bytes.length-i] & 0xFE) | ownerMark[i];
  //   print("k");
  // }
  //print(Directory.current);
  // File outputImageFile = File("/output_image_with_text.jpg");
  // await outputImageFile.writeAsBytes(bytes);
  // return outputImageFile;
  print(bytes.sublist(0,100));
  return bytes;
}



Future<String> stegoDecode(Uint8List bytes) async {
  List<int> textBits = [];
  print(_bitsToText(bytes));
  int startIndex = bytes.length-8-_AppMark.length*8;
  int endIndex = bytes.length-8-_AppMark.length*8-24;
  print(bytes.sublist(bytes.length-100));
  while (startIndex>=endIndex) {
    //if (isValidUtf8(identifierBytes)) {

  List<int> identifierBits = [];  
  List<int> identifierBytes = bytes.sublist(startIndex, startIndex + _AppMark.length*8);
  for(int i=0;i<identifierBytes.length;i++){
      for (int i = startIndex; i < startIndex + _AppMark.length*8; i++) {
        identifierBits.add(identifierBytes[i] & 1);
      }}
    print(_bitsToText(identifierBytes));
    print(_bitsToText([0,1,0,0,0,0,0,1]));
    print(identifierBytes);
    //List<int> identifier = utf8.encode(_AppMark);
    String identifier=_bitsToText(identifierBytes);
    if (identifier == _AppMark) {
      List<int> txtLengthBits = [];
      for (int i = startIndex + _AppMark.length*8; i < bytes.length; i++) {
        txtLengthBits.add(bytes[i] & 1);
      }
      int txtLength=_bitsToText(txtLengthBits) as int;
      for (int i = 0; i < txtLength*8; i++) {
        textBits.add(bytes[i] & 1);
      }
      String decodedTxt=_bitsToText(textBits);
      return decodedTxt;
    }

    startIndex--;
    print("running");
    }
  //}
  return "## Not Endcoded From StegoApp ##";
}

// bool isValidUtf8(List<int> bytes) {
//   try {
//     utf8.decode(bytes, allowMalformed: true);
//     print("true");
//     return true;
//   } catch (_) {
//     print("false");
//     return false;
//   }
// }