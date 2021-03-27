library encrypted_shared_preferences;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';

class EncryptedSharedPreferences {
  final String randomKeyKey = 'randomKey';
  final String randomKeyListKey = 'randomKeyList';
  SharedPreferences? prefs;

  /// Optional: Pass custom SharedPreferences instance
  EncryptedSharedPreferences({this.prefs});

  Future<SharedPreferences> getInstance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    /// If this.prefs null, use internal SharedPreferences instance
    prefs = this.prefs ?? prefs;

    return prefs;
  }

  Encrypter _getEncrypter(SharedPreferences prefs) {
    String? randomKey = prefs.getString(randomKeyKey);

    Key key;
    if(randomKey == null) {
      key = Key.fromLength(32);
      prefs.setString(randomKeyKey, key.base64);
    } else {
      key = Key.fromBase64(randomKey);
    }

    return Encrypter(AES(key));
  }

  Future<bool> setString(String key, String value) async {
    final SharedPreferences prefs = await getInstance();

    final Encrypter encrypter = _getEncrypter(prefs);

    /// Generate random IV
    final IV iv = IV.fromLength(16);
    final String ivValue = iv.base64;

    /// Encrypt value
    final Encrypted encrypted = encrypter.encrypt(value, iv: iv);
    final String encryptedValue = encrypted.base64;

    /// Add generated random IV to a list
    List<String> randomKeyList = prefs.getStringList(randomKeyListKey) ?? [];
    randomKeyList.add(ivValue);
    await prefs.setStringList(randomKeyListKey, randomKeyList);

    /// Save random key list index, We used encrypted value as key so we could use that to access it later
    int index = randomKeyList.length - 1;
    await prefs.setString(encryptedValue, index.toString());

    /// Save encrypted value
    return await prefs.setString(key, encryptedValue);
  }

  Future<String> getString(String key) async {
    String decrypted = '';

    final SharedPreferences prefs = await getInstance();

    /// Get encrypted value
    String? encryptedValue = prefs.getString(key);

    if (encryptedValue != null) {
      /// Get random key list index using the encrypted value as key
      String indexString = prefs.getString(encryptedValue)!;
      int index = int.parse(indexString);

      /// Get random key from random key list using the index
      List<String> randomKeyList = prefs.getStringList(randomKeyListKey)!;
      String ivValue = randomKeyList[index];

      final Encrypter encrypter = _getEncrypter(prefs);

      final IV iv = IV.fromBase64(ivValue);
      final Encrypted encrypted = Encrypted.fromBase64(encryptedValue);

      decrypted = encrypter.decrypt(encrypted, iv: iv);
    }

    return decrypted;
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await getInstance();

    /// Clear values
    return await prefs.clear();
  }

  Future reload() async {
    final SharedPreferences prefs = await getInstance();

    /// Reload
    await prefs.reload();
  }
}
