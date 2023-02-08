import 'package:image_picker/image_picker.dart';

class ImagePickerService{

  final ImagePicker imagePicker = ImagePicker();

  Future<List<XFile>> selectImages() async {
    List<XFile>? imageFileList = [];
    final List<XFile> selectedImages = await
    imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList.addAll(selectedImages);
    }
    return imageFileList;
  }
}