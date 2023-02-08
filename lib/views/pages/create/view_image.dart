import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/data_model.dart';
import '../../../provider/data_provider.dart';

class ImageViewer extends StatefulWidget {
  const ImageViewer({Key? key}) : super(key: key);

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {

  late int catIndex, projectIndex, imageIndex;

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> argReceived = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
    final dataProvider = Provider.of<DataProvider>(context);
    List<DataModel> dataModel = dataProvider.getData;
    catIndex = argReceived["catIndex"];
    projectIndex = argReceived["projectIndex"];
    imageIndex = argReceived["imageIndex"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Image ${imageIndex.toString()}"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.contain,
              width: double.infinity,
              height: double.infinity,
              imageUrl: dataModel[catIndex].projects[projectIndex].images[imageIndex],
              placeholder: (context, url) => Center(
                child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
              useOldImageOnUrlChange: true,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ],
      )
    );
  }
}
