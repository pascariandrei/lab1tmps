import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';

void main() {
  final keyPair = generateRSAKeyPair();

  const inputText = 'Secret';

  try {
    final encryptedBytes = encryptMessage(inputText, keyPair.publicKey);

    final decryptedText = decryptMessage(encryptedBytes, keyPair.privateKey);



    print('Mesaj original: $inputText');
    print('Mesaj criptat: ${base64.encode(encryptedBytes)}');
    print('Mesaj decriptat: $decryptedText');
  }   catch (e) {
    print('Error: ${e}');
  }
}

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair() {
  final secureRandom = SecureRandom('Fortuna')..seed(KeyParameter(Uint8List(32)));
  BigInt p = BigInt.from(61);
  BigInt q = BigInt.from(53);
  BigInt n = p * q;
  const int keyLength = 2048;
  final keyGen = RSAKeyGenerator() //algoritmul de generare a cheii
    ..init(ParametersWithRandom(
      RSAKeyGeneratorParameters(n, keyLength, 64), // 1 - (1/2)^64 probability
      secureRandom,
    ));

  final keyPair = keyGen.generateKeyPair();

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
    keyPair.publicKey as RSAPublicKey,
    keyPair.privateKey as RSAPrivateKey,
  );
}

Uint8List encryptMessage(String plaintext, RSAPublicKey publicKey) {
  final cipher = RSAEngine()..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

  final plaintextBytes = Uint8List.fromList(plaintext.codeUnits);
  return cipher.process(Uint8List.fromList(plaintextBytes));
}

String decryptMessage(Uint8List encryptedBytes, RSAPrivateKey privateKey) {
  final cipher = RSAEngine()..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));

  final decryptedBytes = cipher.process(Uint8List.fromList(encryptedBytes));
  return String.fromCharCodes(decryptedBytes);
}

