import 'package:get/get.dart';
import 'package:trackofyapp/Screens/OnboardingScreen/LoginScreen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 20), () {
      Get.off(() => LoginScreen());
    });
  }
}
