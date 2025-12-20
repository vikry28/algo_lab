import '../entities/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<ProfileEntity?> call(String uid) {
    return repository.getProfile(uid);
  }
}

class WatchProfileUseCase {
  final ProfileRepository repository;

  WatchProfileUseCase(this.repository);

  Stream<ProfileEntity?> call(String uid) {
    return repository.watchProfile(uid);
  }
}

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) {
    return repository.updateProfile(profile);
  }
}
