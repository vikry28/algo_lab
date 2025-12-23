import 'package:algo_lab/features/cryptography_lab/domain/entities/rsa_entity.dart';
import 'package:algo_lab/features/cryptography_lab/domain/usecases/rsa_usecase.dart';
import 'package:algo_lab/features/cryptography_lab/presentation/provider/rsa_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'rsa_provider_test.mocks.dart';

@GenerateMocks([RSAUseCase])
void main() {
  late RSAProvider provider;
  late MockRSAUseCase mockUseCase;

  setUpAll(() {
    // Provide dummy value for BigInt
    provideDummy<BigInt>(BigInt.zero);
  });

  setUp(() {
    mockUseCase = MockRSAUseCase();
  });

  final tKeyPair = RSAKeyPair(
    p: BigInt.from(3),
    q: BigInt.from(11),
    n: BigInt.from(33),
    phi: BigInt.from(20),
    e: BigInt.from(3),
    d: BigInt.from(7),
  );

  group('RSAProvider Tests', () {
    test('Initialization generates new keys', () {
      when(mockUseCase.generateKeyPair()).thenReturn(tKeyPair);

      provider = RSAProvider(useCase: mockUseCase);

      expect(provider.keyPair, tKeyPair);
      expect(provider.inputMessage, "SECRET");
      verify(mockUseCase.generateKeyPair()).called(1);
    });

    test('updateMessage updates state', () {
      when(mockUseCase.generateKeyPair()).thenReturn(tKeyPair);
      provider = RSAProvider(useCase: mockUseCase);

      provider.updateMessage("HELLO");

      expect(provider.inputMessage, "HELLO");
      expect(provider.encryptedValues, isEmpty);
      expect(provider.decryptedValues, isEmpty);
    });

    test('startEncryption encrypts message', () async {
      when(mockUseCase.generateKeyPair()).thenReturn(tKeyPair);
      when(mockUseCase.encrypt(any, any, any)).thenReturn(BigInt.from(99));

      provider = RSAProvider(useCase: mockUseCase);
      provider.updateMessage("A");

      await provider.startEncryption();

      expect(provider.encryptedValues.length, 1);
      expect(provider.encryptedValues.first, BigInt.from(99));
      expect(provider.isEncrypting, false);
    });

    test('startDecryption decrypts values', () async {
      when(mockUseCase.generateKeyPair()).thenReturn(tKeyPair);
      when(mockUseCase.encrypt(any, any, any)).thenReturn(BigInt.from(99));
      when(
        mockUseCase.decrypt(any, any, any),
      ).thenReturn(BigInt.from(65)); // 'A'

      provider = RSAProvider(useCase: mockUseCase);
      provider.updateMessage("A");

      // Manually populate encrypted values to skip encryption delay in test
      provider.encryptedValues = [BigInt.from(99)];

      await provider.startDecryption();

      expect(provider.decryptedValues.length, 1);
      expect(provider.decryptedValues.first, BigInt.from(65));
      expect(provider.decryptedString, "A");
      expect(provider.isDecrypting, false);
    });
  });
}
