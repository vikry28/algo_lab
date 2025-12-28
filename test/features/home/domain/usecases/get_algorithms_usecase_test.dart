import 'package:algo_lab/features/home/domain/entities/algorithm_entity.dart';
import 'package:algo_lab/features/home/domain/repository/algorithm_repository.dart';
import 'package:algo_lab/features/home/domain/usecases/get_algorithms_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_algorithms_usecase_test.mocks.dart';

@GenerateMocks([AlgorithmRepository])
void main() {
  late GetAlgorithmsUseCase usecase;
  late MockAlgorithmRepository mockRepository;

  setUp(() {
    mockRepository = MockAlgorithmRepository();
    usecase = GetAlgorithmsUseCase(mockRepository);
  });

  final tAlgorithms = [
    AlgorithmEntity(
      titleKey: 'bubble_sort',
      descriptionKey: 'bubble_desc',
      title: {'en': 'Bubble Sort'},
      description: {'en': 'Description'},
      icon: 'assets/icon.png',
      colorHex: '#FFFFFF',
      category: 'sorting',
    ),
  ];

  test('should get algorithms from repository', () async {
    when(
      mockRepository.getAllAlgorithms(),
    ).thenAnswer((_) async => tAlgorithms);

    final result = await usecase();

    expect(result, tAlgorithms);
    verify(mockRepository.getAllAlgorithms());
    verifyNoMoreInteractions(mockRepository);
  });
}
