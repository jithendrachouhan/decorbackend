import 'package:backend/models/data_model.dart';
import 'package:backend/services/firebase_data_service.dart';
import 'package:backend/services/image_picker.dart';
import 'package:backend/views/dialogues/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';

class ProjectImagesPage extends StatefulWidget {
  const ProjectImagesPage({Key? key}) : super(key: key);

  @override
  State<ProjectImagesPage> createState() => _ProjectImagesPageState();
}

class _ProjectImagesPageState extends State<ProjectImagesPage> {

  late int catIndex, projectIndex;


  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    List<DataModel> dataModel = dataProvider.getData;
    Map<String,dynamic> argData = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    catIndex = argData["catIndex"] as int;
    projectIndex = argData["projectIndex"] as int;
    return Scaffold(
      appBar: AppBar(
        title: Text(dataModel[catIndex].projects[projectIndex].projectName),
        actions: [
          IconButton(onPressed: () async {
            ImagePickerService imagePickerService = ImagePickerService();
            FirebaseData firebaseData = FirebaseData();
            List<XFile> selectedImages = await imagePickerService.selectImages();
            if(selectedImages.isNotEmpty){
              await firebaseData.uploadImages(imageToUpload: selectedImages, projectModel: dataModel[catIndex].projects[projectIndex]);
              await dataProvider.fetchCatData();
            }
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: dataModel[catIndex].projects[projectIndex].images.length,
            itemBuilder: (context,index){
              return Card(
                elevation: 50,
                shadowColor: Colors.black,
                color: Colors.grey,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/ImageViewer',arguments: {"catIndex":catIndex,"projectIndex":projectIndex,"imageIndex":index});
                  },
                  onLongPress: (){
                    Dialogs.yesNoDialog(
                        context: context,
                        body: 'Are you sure you want to delete it?',
                        yesFunction: () async {
                          FirebaseData fireBaseData = FirebaseData();
                          await fireBaseData.deleteImage(
                              url: dataModel[catIndex].projects[projectIndex].images[index],
                              projectId:dataModel[catIndex].projects[projectIndex].projectID,
                              imagePosition: index);
                          await dataProvider.fetchCatData();
                        });
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Center(
                      child: CachedNetworkImage(
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        imageUrl: dataModel[catIndex].projects[projectIndex].images[index],
                        placeholder: (context, url) => Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.width * 0.3,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        useOldImageOnUrlChange: true,
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              );
            }
        )
      ),
    );
  }
}

