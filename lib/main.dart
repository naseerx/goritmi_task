import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goritmi_task/ui/screens/intro/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/Constants/colors.dart';
import 'core/providers/task_provider.dart';

int? initScreen;
SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  initScreen = (prefs?.getInt("initScreen"));
  prefs?.setInt("initScreen", 1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: GetMaterialApp(
        title: 'Goritmi ToDos',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'MyFont',
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
                centerTitle: true, foregroundColor: kWhite, toolbarHeight: 70),
            scaffoldBackgroundColor: kBGColor),
        initialRoute: initScreen == 0 || initScreen == null ? "/" : "home",
        routes: {
          '/': (context) => const IntroductionScreen(),
          // 'home': (context) => const TasksScreen()
          'home': (context) => const IntroductionScreen()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
