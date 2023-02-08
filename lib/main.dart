import 'package:backend/provider/data_provider.dart';
import 'package:backend/views/pages/create/list_of_projects.dart';
import 'package:backend/views/pages/create/project_images.dart';
import 'package:backend/views/pages/create/view_image.dart';
import 'package:backend/views/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider())
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        routes: {
          '/' : (context) => const HomePage(),
          '/ListOfProjects' : (context) => const ListOfProjects(),
          '/ProjectImagesPage' : (context) => const ProjectImagesPage(),
          '/ImageViewer' : (context) => const ImageViewer(),
        },
      ),
    );
  }
}

