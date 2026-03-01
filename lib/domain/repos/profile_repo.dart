import '../entities/profile_data.dart';

abstract class ProfileRepository {
  ProfileData getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._profile);

  final ProfileData _profile;

  @override
  ProfileData getProfile() => _profile;
}
