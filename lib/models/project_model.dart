import 'package:flutter/cupertino.dart';

class ProjectModel with ChangeNotifier {
  late String projectName;
  late List<String> images;
  late List<String> tags;
  late String projectID;

  ProjectModel({required this.projectName, required this.images, required this.tags,required this.projectID});

}