import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../models/data_model.dart';
import '../models/project_model.dart';

class FirebaseData {

  CollectionReference categoryReference = FirebaseFirestore.instance.collection("CATEGORY");
  CollectionReference projectReference = FirebaseFirestore.instance.collection("PROJECTS");
  Reference imageReference = FirebaseStorage.instance.ref();

  Future<List<DataModel>> getCatList() async {
    final QuerySnapshot data = await categoryReference.get();
    List<DataModel> catData = [];
    for (var element in data.docs){
      List<ProjectModel> projectModel = [];
      for (var element in List.from(element.get("projects"))) {
        print("zzzzzz Stage -1");
        final projectSnapshot = await projectReference.doc(element.toString()).get();
        print("zzzzzz Stage 0");
        if(projectSnapshot.exists){
          print("zzzzzz Stage 1");
          Map<String, dynamic>? projectData = projectSnapshot.data() as Map<String, dynamic>?;
          String projectID = projectSnapshot.reference.id;
          print("zzzzzz Stage 2");
          projectModel.add(
              ProjectModel(
                  projectName: projectData?["project_name"],
                  images: List.from(projectData?["images"]),
                  tags: List.from(projectData?["tags"]),
                  projectID: projectID
              )
          );
          print("zzzzzz Stage 3");
        }
      }
      print("zzzzzz " + projectModel.length.toString());
      catData.add(
          DataModel(
              catName: element.get("cat_name"),
              catID: element.id,
              projects: projectModel
          )
      );
    }
    return catData;
  }

  Future<void> uploadImages({required List<XFile> imageToUpload, required ProjectModel projectModel}) async{
    Reference pathReference = imageReference.child(projectModel.projectName);
    for (var element in imageToUpload) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceImageToUpload = pathReference.child(uniqueFileName);
      try {
        //Store the file
        await referenceImageToUpload.putFile(File(element.path));
        //Success: get the download URL
        String imageURL = await referenceImageToUpload.getDownloadURL();
        List<String> imageURLs = [imageURL];
        await projectReference.doc(projectModel.projectID).update({"images": FieldValue.arrayUnion(imageURLs)});
      } catch (error) {
        continue;
      }
    }
  }

  Future<void> deleteImage({required String url, required String projectId, required int imagePosition}) async {
    await FirebaseStorage.instance.refFromURL(url).delete();
    await projectReference.doc(projectId).update({"images": FieldValue.arrayRemove([url])});
  }

  Future<void> addNewProject({required String projectName, required String catID, required List<String> tags}) async {
    DocumentReference newProject = await projectReference.add({"project_name":projectName,"tags":tags,"images":[]});
    await categoryReference.doc(catID).update({"projects": FieldValue.arrayUnion([newProject.id])});
  }

  Future<void> deleteProjectFromCat({required String projectID, required String catID}) async {
    await categoryReference.doc(catID).update({"projects": FieldValue.arrayRemove([projectID])});
  }

  Future<List<ProjectModel>> getAllProjectList() async {
    List<ProjectModel> returnModel = [];
    final QuerySnapshot data = await projectReference.get();
    for (var element in data.docs) {
      returnModel.add(
          ProjectModel(
          projectName: element.get("project_name"),
          images: List.from(element.get("images")),
          tags: List.from(element.get("tags")),
          projectID: element.id
        )
      );
    }
    return returnModel;
  }

  Future<void> addNewCategory({required catName}) async {
    await categoryReference.add({"cat_name": catName, "projects":[]});
  }

  Future<void> deleteCategory({required String catID}) async {
    await categoryReference.doc(catID).delete();
  }

  Future<void> addExistingProjectToCat({required String projectID, required String catID}) async {
    await categoryReference.doc(catID).update({"projects": FieldValue.arrayUnion([projectID])});
  }

}