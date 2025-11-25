import 'package:get/get.dart';
import '../controllers/motion_controller.dart';

class MotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MotionController>(() => MotionController());
  }
}
