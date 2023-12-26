import 'package:admin/modules/restaurant_details/controllers/restaurant_controller.dart';

import 'package:get/get.dart';


class RestaurantBindings implements Bindings{

  @override
  void dependencies(){
    Get.delete<RestaurantController>(force: true);
    Get.put(RestaurantController(),permanent: true);
  }


}