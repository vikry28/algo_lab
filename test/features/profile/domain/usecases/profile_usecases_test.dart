import 'package:algo_lab/features/profile/domain/entities/profile_entity.dart';
import 'package:algo_lab/features/profile/domain/repository/profile_repository.dart';
import 'package:algo_lab/features/profile/domain/usecases/profile_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_usecases_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late MockProfileRepository mockRepository;
  late GetProfileUseCase getProfileUseCase;
  late UpdateProfileUseCase updateProfileUseCase;
  late WatchProfileUseCase watchProfileUseCase;

  setUp(() {
    mockRepository = MockProfileRepository();
    getProfileUseCase = GetProfileUseCase(mockRepository);
    updateProfileUseCase = UpdateProfileUseCase(mockRepository);
    watchProfileUseCase = WatchProfileUseCase(mockRepository);
  });

  final tProfile = ProfileEntity(
    uid: '123',
    streak: 5,
    totalXP: 100,
    todayXP: 10,
    lastLearnDate: '2023-10-27',
  );

  group('Profile UseCases', () {
    test('getProfile should return profile from repo', () async {
      when(mockRepository.getProfile('123')).thenAnswer((_) async => tProfile);

      final result = await getProfileUseCase('123');

      expect(result, tProfile);
      verify(mockRepository.getProfile('123'));
    });

    test('updateProfile should call repo', () async {
      when(
        mockRepository.updateProfile(tProfile),
      ).thenAnswer((_) async => Future.value());

      await updateProfileUseCase(tProfile);

      verify(mockRepository.updateProfile(tProfile));
    });

    test('watchProfile should return stream from repo', () {
      when(
        mockRepository.watchProfile('123'),
      ).thenAnswer((_) => Stream.value(tProfile));

      final result = watchProfileUseCase('123');

      expect(result, emits(tProfile));
      verify(mockRepository.watchProfile('123'));
    });
  });
}
