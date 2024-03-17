import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

String _AppMark='StegoApp';

List<int> _textToBits(String txt){
  List<int> textBytes = utf8.encode(txt);
  List<int> textBits = [];
  for (int byte in textBytes) {
    for (int i = 0; i < 8; i++) {
      textBits.add((byte >> (7 - i)) & 1);
    }
  }
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

Future<File> stegoEncode(File imageFile,String textToHide) async {
  Uint8List bytes = await imageFile.readAsBytes();
  final textBits = _textToBits(textToHide);
  final ownerMark=_textToBits("$_AppMark${textToHide.length}");
  for (int i = 0; i < textBits.length; i++) {
    bytes[i] = (bytes[i] & 0xFE) | textBits[i];
  }
  for (int i = ownerMark.length -1; i>=0 ; i++){
    bytes[bytes.length-i]=(bytes[bytes.length-i] & 0xFE) | ownerMark[i];
  }

  File outputImageFile = File('output_image_with_text.jpg');
  await outputImageFile.writeAsBytes(bytes);
  return outputImageFile;
}

Future<String> stegoDecode(File imageFile) async {
  Uint8List bytes = await imageFile.readAsBytes();
  List<int> textBits = [];
  int startIndex = bytes.length-8-_AppMark.length;
  while (startIndex>=0) {
    List<int> identifierBytes = bytes.sublist(startIndex, startIndex + _AppMark.length);
    String identifier = utf8.decode(identifierBytes);
    
    if (identifier == _AppMark) {
      List<int> txtLengthBits = [];
      for (int i = startIndex + _AppMark.length; i < bytes.length; i++) {
        txtLengthBits.add(bytes[i] & 1);
      }
      int txtLength=_bitsToText(txtLengthBits) as int;
      for (int i = 0; i < txtLength; i++) {
        textBits.add(bytes[i] & 1);
      }
      String decodedTxt=_bitsToText(textBits);
      return decodedTxt;
    }

    startIndex--;
  }
  return "## Not Endcoded From StegoApp ##";
}