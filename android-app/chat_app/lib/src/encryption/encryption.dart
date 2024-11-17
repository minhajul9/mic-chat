import 'dart:convert';
import 'package:chat_app/src/encryption/aeseverywhere.dart';

String secretKey = "d+KL19{1,3&hemyT@Uu({KMftS!khDfF";

String encryptData(dynamic data, bool isString) {
  final String stringData = data is String ? data : jsonEncode(data);

  var encrypted = Aes256.encrypt(stringData, secretKey);

  if (isString && encrypted.contains('/')) {
    encrypted = encryptData(data, isString);
  }

  return encrypted;
}

decryptData(dynamic encrypted) {
  final decrypted = Aes256.decrypt(encrypted, secretKey);

  return json.decode(decrypted!);
}
