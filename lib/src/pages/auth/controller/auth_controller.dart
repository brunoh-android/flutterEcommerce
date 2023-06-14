import 'package:app_quitanda/src/constants/storage_keys.dart';
import 'package:app_quitanda/src/models/user_model.dart';
import 'package:app_quitanda/src/pages/auth/repository/auth_repository.dart';
import 'package:app_quitanda/src/pages/auth/result/auth_result.dart';
import 'package:app_quitanda/src/pages_route/app_pages.dart';
import 'package:app_quitanda/src/services/utlis_service.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();
  final utilsService = UtilsService();

  UserModel user = UserModel();

  @override
  void onInit() {
    super.onInit();
    validateToken();
  }

  void saveTokenAndProceedToBase() {
    utilsService.saveLocalData(key: StorageKeys.token, data: user.token!);
    Get.offAllNamed(PagesRoutes.baseRoute);
  }

  Future<void> validateToken() async {
    String? token = await utilsService.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PagesRoutes.signInRoute);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);
    result.when(sucess: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (error) {
      signOut();
    });
  }

  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
        token: user.token!);
    isLoading.value = false;
    if (result) {
      utilsService.showToast(message: 'Senha atualizada');
      signOut();
    } else {
      utilsService.showToast(message: 'Senha incorreta', isError: true);
    }
  }

  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  Future<void> signUp() async {
    isLoading.value = true;
    AuthResult result = await authRepository.signUp(user);
    isLoading.value = false;

    result.when(sucess: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (error) {
      utilsService.showToast(message: error, isError: true);
    });
  }

  Future<void> signOut() async {
    user = UserModel();
    await utilsService.removeLocalData(key: StorageKeys.token);
    Get.offAllNamed(PagesRoutes.signInRoute);
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    result.when(sucess: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (message) {
      utilsService.showToast(message: message, isError: true);
    });
  }
}
