import 'package:backend/services/firebase_data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/data_model.dart';
import '../../provider/data_provider.dart';
import '../dialogues/dialogs.dart';
import '../widgets/button_widget.dart';
import '../widgets/global_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final TextEditingController _nameController = TextEditingController();
  String newCatName = "";
  FirebaseData firebaseData = FirebaseData();

  @override
  void initState() {
    // TODO: implement initState
    final dataProvider = Provider.of<DataProvider>(context,listen: false);
    dataProvider.fetchAllProjects();
    dataProvider.fetchCatData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    List<DataModel> dataModel = dataProvider.getData;
    return Scaffold(
      appBar: AppBar(
        title: const Text("DECORTEAM BACKEND"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                await _addNewProjectDialog(context);
                if(newCatName.isNotEmpty){
                  await firebaseData.addNewCategory(catName: newCatName);
                  await dataProvider.fetchCatData();
                }
              },
              child: const Text("Create New Category")
            ),
            const SizedBox(height: 20,),
            GridView.builder(
              shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: dataModel.length,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 50,
                    shadowColor: Colors.black,
                    color: Colors.grey,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, "/ListOfProjects",arguments: index);
                      },
                      onLongPress: (){
                        Dialogs.yesNoDialog(
                            context: context,
                            body: "Do you want to delete this category??",
                            yesFunction: () async {
                              await firebaseData.deleteCategory(catID: dataModel[index].catID);
                              await dataProvider.fetchCatData();
                            }
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.width * 0.3,
                        child: Center(
                          child: Text(
                            dataModel[index].catName,
                            style:const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
            )
          ],
        ),
      ),
    );
  }


  Future<void> _addNewProjectDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add New Category'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  newCatName = value;
                });
              },
              controller: _nameController,
              decoration: const  InputDecoration(
                  hintText: "Text Field in Dialog"
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  if(newCatName.isEmpty){
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

}

