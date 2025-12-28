import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import '../../domain/entities/rsa_entity.dart';
import '../../domain/usecases/rsa_usecase.dart';

enum RSAScenario { encryption, signature }

class RSAProvider extends ChangeNotifier {
  final RSAUseCase _useCase;

  RSAKeyPair? keyPair;
  String inputMessage = "SECURE-PAY-100";
  List<BigInt> encryptedValues = [];
  List<BigInt> decryptedValues = [];

  // Realistic Hashing
  String messageHash = "";
  List<BigInt> signature = [];
  bool isVerified = false;

  bool isProcessing = false;
  int currentStepIdx = -1;
  RSAScenario currentScenario = RSAScenario.encryption;

  RSAProvider({RSAUseCase? useCase}) : _useCase = useCase ?? RSAUseCase() {
    generateNewKeys();
  }

  void setScenario(RSAScenario scenario) {
    currentScenario = scenario;
    resetState();
    notifyListeners();
  }

  void resetState() {
    encryptedValues = [];
    decryptedValues = [];
    signature = [];
    messageHash = "";
    isVerified = false;
    currentStepIdx = -1;
  }

  void generateNewKeys() {
    keyPair = _useCase.generateKeyPair();
    resetState();
    notifyListeners();
  }

  void updateMessage(String msg) {
    if (msg.length > 25) msg = msg.substring(0, 25);
    inputMessage = msg.toUpperCase();
    resetState();
    notifyListeners();
  }

  Future<void> runScenario() async {
    if (keyPair == null || isProcessing) return;
    isProcessing = true;
    resetState();
    notifyListeners();

    if (currentScenario == RSAScenario.encryption) {
      await _runEncryptionFlow();
    } else {
      await _runSignatureFlow();
    }

    isProcessing = false;
    notifyListeners();
  }

  Future<void> _runEncryptionFlow() async {
    final bytes = utf8.encode(inputMessage);
    for (int i = 0; i < bytes.length; i++) {
      currentStepIdx = i;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));

      final cipher = _useCase.encrypt(
        BigInt.from(bytes[i]),
        keyPair!.e,
        keyPair!.n,
      );
      encryptedValues.add(cipher);
      notifyListeners();
    }

    await Future.delayed(const Duration(milliseconds: 600));

    for (int i = 0; i < encryptedValues.length; i++) {
      currentStepIdx = i;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 300));

      final plain = _useCase.decrypt(
        encryptedValues[i],
        keyPair!.d,
        keyPair!.n,
      );
      decryptedValues.add(plain);
      notifyListeners();
    }
    currentStepIdx = -1;
  }

  Future<void> _runSignatureFlow() async {
    // 1. Hashing
    messageHash = sha256.convert(utf8.encode(inputMessage)).toString();
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    // 2. Signing (Encrypt hash with Private Key)
    final hashBytes = utf8.encode(
      messageHash.substring(0, 8),
    ); // Sample first 8 chars for visualization
    for (int i = 0; i < hashBytes.length; i++) {
      currentStepIdx = i;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
      // Signing: Use d for encryption
      final sig = _useCase.encrypt(
        BigInt.from(hashBytes[i]),
        keyPair!.d,
        keyPair!.n,
      );
      signature.add(sig);
      notifyListeners();
    }

    await Future.delayed(const Duration(seconds: 1));

    // 3. Verifying (Decrypt with Public Key)
    List<int> verifiedHashBytes = [];
    for (int i = 0; i < signature.length; i++) {
      currentStepIdx = i;
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 200));
      // Verify: Use e for decryption
      final plain = _useCase.decrypt(signature[i], keyPair!.e, keyPair!.n);
      verifiedHashBytes.add(plain.toInt());
      notifyListeners();
    }

    final verifiedSubHash = String.fromCharCodes(verifiedHashBytes);
    isVerified = verifiedSubHash == messageHash.substring(0, 8);
    currentStepIdx = -1;
    notifyListeners();
  }

  String get decryptedString {
    if (decryptedValues.isEmpty) return "";
    return utf8.decode(
      decryptedValues.map((e) => e.toInt()).toList(),
      allowMalformed: true,
    );
  }
}
