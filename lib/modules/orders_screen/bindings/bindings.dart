import 'package:admin/modules/orders_screen/controller/orders_controller.dart';
import 'package:get/get.dart';


class OrdersBindings implements Bindings{

  @override
  void dependencies(){
    Get.put(OrdersController(),permanent: true);
  }

}