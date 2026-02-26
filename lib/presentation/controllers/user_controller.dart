import 'package:get/get.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/get_users.dart';

class UserController extends GetxController {
  final GetUsers getUsersUsecase;
  final GetUserById getUserByIdUsecase;

  UserController(this.getUsersUsecase, this.getUserByIdUsecase);

  // Separate loading states — no more race conditions
  final RxBool isUsersLoading = false.obs;
  final RxBool isUserDetailLoading = false.obs;

  final RxString usersError = ''.obs;
  final RxString userDetailError = ''.obs;

  final RxList<User> users = <User>[].obs;
  final Rx<User?> selectedUser = Rx<User?>(null);

  Future<void> fetchUsers() async {
    _runGuarded(
      loading: isUsersLoading,
      error: usersError,
      action: () async {
        final result = await getUsersUsecase();
        users.assignAll(result);
      },
    );
  }

  Future<void> fetchUserById(int id) async {
    _runGuarded(
      loading: isUserDetailLoading,
      error: userDetailError,
      action: () async {
        final result = await getUserByIdUsecase(id);
        selectedUser.value = result;
      },
    );
  }

  /// Single unified execution wrapper — DRY, consistent, and type-safe
  Future<void> _runGuarded({
    required RxBool loading,
    required RxString error,
    required Future<void> Function() action,
  }) async {
    try {
      loading.value = true;
      error.value = '';
      await action();
    } on AppException catch (e) {
      // All your custom exceptions are AppException — one catch handles all
      error.value = e.message;
    } catch (e) {
      // True unknown — something not from your error layer
      error.value = "An unexpected error occurred.";
    } finally {
      loading.value = false;
    }
  }
}