import 'package:flutter_test/flutter_test.dart';
import 'package:algo_lab/features/cryptography_lab/domain/usecases/rsa_usecase.dart';

void main() {
  late RSAUseCase rsaUseCase;

  setUp(() {
    rsaUseCase = RSAUseCase();
  });

  group('RSAUseCase Tests', () {
    test('Key generation should produce valid RSA keys', () {
      final keyPair = rsaUseCase.generateKeyPair();

      expect(keyPair.p, isNot(keyPair.q));
      expect(keyPair.n, equals(keyPair.p * keyPair.q));

      final phi = (keyPair.p - BigInt.one) * (keyPair.q - BigInt.one);
      expect(keyPair.phi, equals(phi));

      // Check if e and phi are coprime
      expect(_gcd(keyPair.e, keyPair.phi), equals(BigInt.one));

      // Check if (e * d) % phi == 1
      expect((keyPair.e * keyPair.d) % keyPair.phi, equals(BigInt.one));
    });

    test('Encryption and decryption should be consistent', () {
      final keyPair = rsaUseCase.generateKeyPair();
      final originalMessage = BigInt.from(65); // ASCII 'A'

      final encrypted = rsaUseCase.encrypt(
        originalMessage,
        keyPair.e,
        keyPair.n,
      );
      final decrypted = rsaUseCase.decrypt(encrypted, keyPair.d, keyPair.n);

      expect(decrypted, equals(originalMessage));
    });

    test('Encrypting multiple blocks (String demo)', () {
      final keyPair = rsaUseCase.generateKeyPair();
      const message = "HELLO";

      final encryptedBlocks = message.codeUnits
          .map(
            (unit) =>
                rsaUseCase.encrypt(BigInt.from(unit), keyPair.e, keyPair.n),
          )
          .toList();

      final decryptedUnits = encryptedBlocks
          .map(
            (cipher) =>
                rsaUseCase.decrypt(cipher, keyPair.d, keyPair.n).toInt(),
          )
          .toList();

      final decryptedMessage = String.fromCharCodes(decryptedUnits);

      expect(decryptedMessage, equals(message));
    });
  });
}

BigInt _gcd(BigInt a, BigInt b) {
  while (b != BigInt.zero) {
    final t = b;
    b = a % b;
    a = t;
  }
  return a;
}
