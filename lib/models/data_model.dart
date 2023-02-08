import 'package:backend/models/project_model.dart';
import 'package:flutter/cupertino.dart';

class DataModel with ChangeNotifier{
  late String catName;
  late String catID;
  late List<ProjectModel> projects;

  DataModel({required this.catName,required this.catID, required this.projects});
}