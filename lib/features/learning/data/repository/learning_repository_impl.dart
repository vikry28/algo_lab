import '../../domain/entities/learning_entity.dart';
import '../../domain/repository/learning_repository.dart';
import '../datasources/learning_remote_datasource.dart';

class LearningRepositoryImpl implements LearningRepository {
  final LearningRemoteDataSource remoteDataSource;

  LearningRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<LearningEntity>> getLearningItems() async {
    final items = await remoteDataSource.fetchLearningItems();
    return items;
  }
}
