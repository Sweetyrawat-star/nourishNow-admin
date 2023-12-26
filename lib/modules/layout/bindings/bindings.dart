import 'package:admin/modules/layout/controllers/layout_controller.dart';

import 'package:get/get.dart';


class LayOutBindings implements Bindings{

  @override
  void dependencies(){
    Get.put(LayoutController(),permanent: true);
  }


}