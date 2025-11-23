import 'package:get/get.dart';
import '../../../../services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() async {
    // Simulasi delay animasi (misal 2 detik)
    await Future.delayed(const Duration(milliseconds: 9500));

    if (_auth.isLoggedIn.value) {
      Get.offAllNamed(Routes.DASHBOARD);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}