import 'package:amalyot_browser/services/hive_service.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HiveService());
  }
}
