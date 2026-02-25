import 'package:get/get.dart';

import '../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user_by_id.dart';
import '../../domain/usecases/get_users.dart';

class UserController extends GetxController {
  final GetUsers getUsersUsecase;
  final GetUserById getUserByIdUsecase;

  UserController(this.getUsersUsecase, this.getUserByIdUsecase);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<User> users = <User>[].obs;
  Rx<User?> selectedUser = Rx<User?>(null);

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getUsersUsecase();
      users.assignAll(result);
    }
    catch (e) {
      if (e is NoInternetException) {
        errorMessage.value = e.message;
      } else if (e is TimeoutException) {
        errorMessage.value = e.message;
      } else if (e is BadRequestException) {
        errorMessage.value = e.message;
      } else if (e is UnauthorizedException) {
        errorMessage.value = e.message;
      } else if (e is ForbiddenException) {
        errorMessage.value = e.message;
      } else if (e is NotFoundException) {
        errorMessage.value = e.message;
      } else if (e is ServerException) {
        errorMessage.value = e.message;
      } else if (e is ServiceUnavailableException) {
        errorMessage.value = e.message;
      } else if (e is UnexpectedStatusException) {
        errorMessage.value = e.message;
      } else if (e is InvalidResponseException) {
        errorMessage.value = e.message;
      } else if (e is UnknownException) {
        errorMessage.value = e.message;
      } else {
        errorMessage.value = "Unexpected error occurred.";
      }
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserById(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getUserByIdUsecase(id);
      selectedUser.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}