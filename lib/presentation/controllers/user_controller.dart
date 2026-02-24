import '../../domain/usecases/get_users.dart';
import '../../domain/entities/user.dart';

class UserController {
  final GetUsers getUsersUseCase;

  UserController(this.getUsersUseCase);

  Future<List<User>> fetchUsers() async {
    return await getUsersUseCase();
  }
}