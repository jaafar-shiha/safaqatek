import 'dart:convert';
import 'dart:io';

extension FileExts on File {
  String get base64Encode => base64.encode(readAsBytesSync());
}
