import 'package:algo_lab/features/cryptography_lab/domain/usecases/rsa_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late RSAUseCase useCase;

  setUp(() {
    useCase = RSAUseCase();
  });

  group('RSAUseCase Tests', () {
    test('generateKeyPair returns valid keys', () {
      final keyPair = useCase.generateKeyPair();

      expect(keyPair.p, isNotNull);
      expect(keyPair.q, isNotNull);
      expect(keyPair.n, keyPair.p * keyPair.q);
      expect(keyPair.e, isNotNull);
      expect(keyPair.d, isNotNull);
    });

    test('Encryption and Decryption are reversible', () {
      // Use small primes for deterministic testing derived check
      // p=11, q=13 -> n=143, one of the possible outcomes
      // Instead, we verify the property M = (M^e)^d mod n

      // Let's rely on the generateKeyPair to give us a valid pair
      final keyPair = useCase.generateKeyPair();
      final originalMessage = BigInt.from(65); // 'A'

      final encrypted = useCase.encrypt(originalMessage, keyPair.e, keyPair.n);
      final decrypted = useCase.decrypt(encrypted, keyPair.d, keyPair.n);

      expect(decrypted, originalMessage);

      // Test another value - ensure it's smaller than n
      if (keyPair.n > BigInt.from(42)) {
        final valSmall = BigInt.from(42);
        final encSmall = useCase.encrypt(valSmall, keyPair.e, keyPair.n);
        final decSmall = useCase.decrypt(encSmall, keyPair.d, keyPair.n);
        expect(decSmall, valSmall);
      }
    });
  });
}
