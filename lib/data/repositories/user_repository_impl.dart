import '../../core/network/api_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_models.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);

  @override
  Future<List<User>> getUsers() async {
    return await apiService.get(
        url: "https://jsonplaceholder.typicode.com/users",
        fromJson: (json) => (json as List)
        .map((item) => UserModel.fromJson(item))
        .toList(),
    );
  }

  @override
  Future<User> getUserById(int id) async {
    return await apiService.get(
      url: "https://jsonplaceholder.typicode.com/users/$id",
      fromJson: (json) => UserModel.fromJson(json),
    );
  }
}