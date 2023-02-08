import 'package:backend/models/data_model.dart';
import 'package:backend/models/project_model.dart';
import 'package:backend/services/firebase_data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../widgets/global_widgets.dart';


class ListOfProjects extends StatefulWidget {
  const ListOfProjects({Key? key}) : super(key: key);

  @override
  State<ListOfProjects> createState() => _ListOfProjectsState();
}

class _ListOfProjectsState extends State<ListOfProjects> {

  late int catIndex;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  String newProjectName = "";
  String newProjectsTags = "";
  String selectedProjectId = "";
  FirebaseData firebaseData = FirebaseData();

  @override
  Widget build(BuildContext context) {
    final catProvider = Provider.of<DataProvider>(context);
    List<DataModel> dataModel = catProvider.getData;
    List<ProjectModel> projectModels = catProvider.getProjects;
    catIndex = ModalRoute.of(context)?.settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text(dataModel[catIndex].catName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        await _addNewProjectDialog(context);
                        if(newProjectsTags.isNotEmpty || newProjectName.isNotEmpty){
                          List<String> tags = newProjectsTags.split(' ');
                          tags.add(newProjectName);
                          await firebaseData.addNewProject(projectName: newProjectName, catID: dataModel[catIndex].catID, tags: tags);
                          await catProvider.fetchCatData();
                          await catProvider.fetchAllProjects();
                        }
                      },
                      child: const Text("Add new project")),
                  ElevatedButton(
                      onPressed: () async {
                        await _addExistingProjectDialog(context,projectModels);
                        if(selectedProjectId.isNotEmpty){
                          await firebaseData.addExistingProjectToCat(projectID: selectedProjectId, catID:dataModel[catIndex].catID);
                        }
                        await catProvider.fetchCatData();
                      },
                      child: const Text("Add existing project")),
                ],
              ),
              const SizedBox(height: 18),
              ListView.builder(
                shrinkWrap: true,
                itemCount: dataModel[catIndex].projects.length,
                itemBuilder: (context,index){
                  return GestureDetector(
                      onTap: (){
                          Navigator.pushNamed(context, "/ProjectImagesPage",arguments: {"catIndex":catIndex,"projectIndex": index});
                        },
                      child: projectCard(
                          projectName: dataModel[catIndex].projects[index].projectName,
                          catID :dataModel[catIndex].catID,
                          onPressed: () async {
                            await firebaseData.deleteProjectFromCat(projectID: dataModel[catIndex].projects[index].projectID, catID: dataModel[catIndex].catID);
                            await catProvider.fetchCatData();
                          }
                      )
                  );
                }
              )
            ],
          ),
        )
      ),
    );
  }

  Widget projectCard({required String projectName, required String catID, required Function onPressed}){
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(projectName),
          IconButton(
              onPressed: (){
                onPressed();
              },
          icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }

  //==========================================================================On page dialogs================================================================================
  Future<void> _addNewProjectDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Project'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newProjectName = value;
                    });
                  },
                  controller: _nameController,
                  decoration: const  InputDecoration(
                      hintText: "Text Field in Dialog"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  onChanged: (value) {
                    newProjectsTags = value;
                  },
                  controller: _tagsController,
                  decoration: const  InputDecoration(
                      hintText: "Text Field in Dialog"
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if(newProjectsTags.isEmpty || newProjectName.isEmpty){
                    GlobalWidgets.showErrorMessage(context: context, message: "Text Filed Should not be empty");
                  }else{
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }
  Future<void> _addExistingProjectDialog(BuildContext context,List<ProjectModel> projectModels) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Click on the project which you want to add'),
            content: SizedBox(
              width: 300,
              height: 400,
              child: ListView.builder(
                shrinkWrap: true,
                  itemCount: projectModels.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        selectedProjectId = projectModels[index].projectID;
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        color: Colors.grey,
                        height: 30,
                        width: double.infinity,
                        child: Text(projectModels[index].projectName),
                      )
                    );
                  }
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


}
