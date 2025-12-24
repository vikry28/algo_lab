import 'package:flutter/material.dart';
import '../../domain/entities/rsa_entity.dart';
import '../../domain/usecases/rsa_usecase.dart';

class RSAProvider extends ChangeNotifier {
  final RSAUseCase _useCase;

  RSAKeyPair? keyPair;
  String inputMessage = "SECRET";
  List<BigInt> encryptedValues = [];
  List<BigInt> decryptedValues = [];

  bool isEncrypting = false;
  bool isDecrypting = false;

  int currentBlockIdx = -1;

  RSAProvider({RSAUseCase? useCase}) : _useCase = useCase ?? RSAUseCase() {
    generateNewKeys();
  }

  void generateNewKeys() {
    keyPair = _useCase.generateKeyPair();
    inputMessage = "SECRET";
    encryptedValues = [];
    decryptedValues = [];
    currentBlockIdx = -1;
    notifyListeners();
  }

  void updateMessage(String msg) {
    if (msg.length > 20) msg = msg.substring(0, 20);
    inputMessage = msg.toUpperCase();
    encryptedValues = [];
    decryptedValues = [];
    notifyListeners();
  }

  Future<void> startEncryption() async {
    if (keyPair == null || isEncrypting) return;

    isEncrypting = true;
    encryptedValues = [];
    decryptedValues = [];
    notifyListeners();

    final bytes = inputMessage.codeUnits;
    for (int i = 0; i < bytes.length; i++) {
      currentBlockIdx = i;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 400));

      final val = BigInt.from(bytes[i]);
      final cipher = _useCase.encrypt(val, keyPair!.e, keyPair!.n);
      encryptedValues.add(cipher);
      notifyListeners();
    }

    currentBlockIdx = -1;
    isEncrypting = false;
    notifyListeners();
  }

  Future<void> startDecryption() async {
    if (keyPair == null || isDecrypting || encryptedValues.isEmpty) return;

    isDecrypting = true;
    decryptedValues = [];
    notifyListeners();

    for (int i = 0; i < encryptedValues.length; i++) {
      currentBlockIdx = i;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 400));

      final plain = _useCase.decrypt(
        encryptedValues[i],
        keyPair!.d,
        keyPair!.n,
      );
      decryptedValues.add(plain);
      notifyListeners();
    }

    currentBlockIdx = -1;
    isDecrypting = false;
    notifyListeners();
  }

  String get decryptedString {
    return String.fromCharCodes(decryptedValues.map((e) => e.toInt()));
  }
}
