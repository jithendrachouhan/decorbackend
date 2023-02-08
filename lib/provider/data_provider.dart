import 'package:backend/models/project_model.dart';
import 'package:backend/services/firebase_data_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/data_model.dart';

class DataProvider with ChangeNotifier{

  FirebaseData firebaseData = FirebaseData();

  List<DataModel> _catData = [];

  List<ProjectModel> _allProjects = [];

  List<DataModel> get getData{
    return _catData;
  }

  List<ProjectModel> get getProjects{
    return _allProjects;
  }

  Future<void> fetchCatData() async {
    _catData = await firebaseData.getCatList();
    notifyListeners();

  }

  Future<void> fetchAllProjects() async{
    _allProjects = await firebaseData.getAllProjectList();
    notifyListeners();
  }

}