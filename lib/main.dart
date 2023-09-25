import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:encrypt/encrypt.dart';

void main() {
  const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  final aesKey = Key.fromUtf8('123456789abcdefd');

  final initializationVector = IV.fromUtf8(getRandomString(16));
  final encrypter = Encrypter(AES(aesKey, mode: AESMode.cbc));

  const inputFile = 'D:/Anul VII/dart single file run project/lib/input.txt';
  const encryptedFile = 'D:/Anul VII/dart single file run project/lib/encrypted.txt';
  const decryptedFile = 'D:/Anul VII/dart single file run project/lib/decrypted.txt';

  final inputFileContent = File(inputFile).readAsStringSync();

  final encryptedData = encrypter.encrypt(inputFileContent, iv: initializationVector);
  File(encryptedFile).writeAsStringSync(encryptedData.base64);

  final decryptedData = encrypter.decrypt64(File(encryptedFile).readAsStringSync(), iv: initializationVector);
  File(decryptedFile).writeAsStringSync(decryptedData);

  print(utf8.decode(initializationVector.bytes));
  print(File(encryptedFile).readAsStringSync());
  print(decryptedData);
}
