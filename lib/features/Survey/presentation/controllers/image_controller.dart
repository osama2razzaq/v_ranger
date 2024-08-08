import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var images = <XFile>[].obs;

  Future<void> pickImage() async {
    if (images.length < 5) {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        images.add(image);
      }
    } else {
      // Limit reached, show a message
      Get.snackbar('Limit Reached', 'You can upload a maximum of 5 images');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }
}
