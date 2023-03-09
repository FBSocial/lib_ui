import 'package:flutter/material.dart' hide TextButton;
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:lib_theme/lib_theme.dart';
import 'package:lib_ui/lib_ui.dart';

import 'pages/button_example_page.dart';
import 'pages/dialog_example_page.dart';

const kRouteButtons = "buttons";
const kRouteDialogs = "dialogs";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppTheme(
        theme: AppThemeData.light(),
        darkTheme: AppThemeData.dark(),
        child: FbTheme(
          child: GetMaterialApp(
            title: 'Flutter Demo',
            home: const MyHomePage(),
            routes: {
              kRouteButtons: (_) => const ButtonExamplePage(),
              kRouteDialogs: (_) => const DialogExamplePage()
            },
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FB THEME"),
      ),
      body: ListView(
        children: [
          buildCard(context, "按钮", kRouteButtons),
          buildCard(context, "对话框", kRouteDialogs),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Card buildCard(BuildContext context, String title, String route) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          children: [
            FbTextButton.primary(
              title,
              onTap: () => Navigator.of(context).pushNamed(route),
            ),
          ],
        ),
      ),
    );
  }
}
