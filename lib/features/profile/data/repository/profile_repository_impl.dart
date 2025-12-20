import '../../../../core/services/firestore_service.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreService firestoreService;

  ProfileRepositoryImpl({required this.firestoreService});

  @override
  Future<ProfileEntity?> getProfile(String uid) async {
    final userModel = await firestoreService.getUser(uid);
    return userModel?.toEntity();
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final userModel = UserModel.fromEntity(profile);
    // Depending on what we want to update.
    // Let's use the createUser/syncUserProfile logic or a specific update.
    // For general profile update (name, photo):
    await firestoreService.syncUserProfile(userModel);
  }

  @override
  Stream<ProfileEntity?> watchProfile(String uid) {
    return firestoreService.userStream(uid).map((model) => model?.toEntity());
  }
}
