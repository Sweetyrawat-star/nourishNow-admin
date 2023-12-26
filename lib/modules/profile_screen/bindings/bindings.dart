import 'package:admin/modules/profile_screen/controllers/profile_controller.dart';
import 'package:get/get.dart';


class ProfileBindings implements Bindings{

  @override
   void dependencies(){
    Get.put(ProfileController(),permanent: true);
  }

}