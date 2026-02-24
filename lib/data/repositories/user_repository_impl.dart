
import '../../core/network/api_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_models.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;

  UserRepositoryImpl(this.apiService);


  @override
  Future<List<User>> getUsers() async {
    final data = await apiService.get(
        'https://jsonplaceholder.typicode.com/users');
    return data.map<User>((json) => UserModel.fromJson(json)).toList();
  }
}