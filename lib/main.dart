import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refine_basic/Screens/DetailScreen.dart';
import 'package:refine_basic/Screens/SplashScreen.dart';
import 'package:refine_basic/Service/NotificationService.dart';
import 'package:refine_basic/Service/UserDataStorage.dart';
import 'package:refine_basic/Utils/ColorModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/HabitListScreen.dart';
import 'State/HabitProvider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();
  // Check for existing user data
  final userData = await UserDataStorage.getUserData();
  final initialRoute = userData != null ? '/home' : '/details';

  final prefs = await SharedPreferences.getInstance();
  final savedColor = prefs.getInt('selectedColor') ?? 0;
  runApp(  MultiProvider(
    providers: [
      ChangeNotifierProvider(
      create: (context) => HabitProvider(),
    ),
      ChangeNotifierProvider(create: (_) => ColorModel(savedColor)),
  ],
    child: MyApp(initialRoute: initialRoute,),

  ),);
}





class MyApp extends StatefulWidget {

  final String initialRoute;
  const MyApp({Key? key, required this.initialRoute}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  bool _isDarkMode = false;

  void _toggleTheme() async{
    setState((){
      _isDarkMode = !_isDarkMode;
    });

  }

  @override
  Widget build(BuildContext context)  {


    return Consumer<ColorModel>(
      builder: (context,colorModel,child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Habit Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: colorModel.selectedColor),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: widget.initialRoute,
        routes: {
        '/home': (context) => HabitListScreen(),
        '/details': (context) => DetailScreen(
        onPressed: _toggleTheme,
        isDarkMode: _isDarkMode,
        ),
        // Add other routes as needed
        },
        home: DetailScreen( onPressed: _toggleTheme, isDarkMode:_isDarkMode)
        // HabitListScreen(),
      );
      }
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}