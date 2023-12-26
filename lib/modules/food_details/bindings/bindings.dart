
import 'package:admin/modules/food_details/controllers/food_controller.dart';
import 'package:get/get.dart';


class FoodBindings implements Bindings{

  @override
  void dependencies(){
    Get.put(FoodController());
  }
}